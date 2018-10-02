function Install-PSProfileTools
{
    <#
        .SYNOPSIS 
        Creates ProfileTools Config

        .DESCRIPTION
        The ProfileTools Config saves the import- and exportpaths for your PowerShell Profile.

        .PARAMETER ConfigPath
        The Path to the ProfileTools Config

        .PARAMETER ExportPath
        The Path the module will use to save your PowerShell Profile to.

        .EXAMPLE
        C:\PS> Install-ProfileTools -ConfigPath "C:\Temp\" -ConfigName "ProfileSettings.json" -ExportPath "C:\Setup\Profile"

        .EXAMPLE
        C:\PS> Install-ProfileTools -ExportPath "C:\Setup\Profile"
    #>
    [CMDletBinding()]
    param
    (
        [Parameter()]
        [string]$ConfigPath = "$env:USERPROFILE\ProfileTools",
        [Parameter()]
        [string]$ConfigName = "ProfileSettings.json",
        [Parameter(Mandatory)]
        [string]$ExportPath
    )

    if(!(Test-Path -Path $ConfigPath))
    {
        New-Item -ItemType Directory -Path $ConfigPath -Force
    }

    $Config = New-Object -TypeName psobject
    Add-Member -InputObject $Config -MemberType NoteProperty -Name "ExportPath" -Value $ExportPath
    Add-Member -InputObject $Config -MemberType NoteProperty -Name "ConsoleProfile" -Value "Microsoft.PowerShell_profile.ps1"
    Add-Member -InputObject $Config -MemberType NoteProperty -Name "ISEProfile" -Value "Microsoft.PowerShellISE_profile.ps1"

    $Config = $Config | Convertto-json -Depth 100 
    New-Item -ItemType File -Path "$ConfigPath\$ConfigName" -Value $Config -Force | Out-Null
    New-Item -Path HKLM:\Software\ProfileTools -Value "$ConfigPath\$ConfigName" -Force | Out-Null
}

function Get-PSProfile
{
    [CMDletBinding()]
    param
    (
        [Parameter()]
        [switch]$Force
    )

   
    $Config = (Get-Content -Path ((Get-ItemProperty -Path HKLM:\Software\ProfileTools).psobject.properties.value[0]) | ConvertFrom-Json)
    
    $Path = $Config.ExportPath
    $ConsoleProfileName = $Config.ConsoleProfile
    $ISEProfileName = $Config.ISEProfile

    $ProfilePath = "$env:USERPROFILE\Documents\WindowsPowerShell\"
    $ProfilePathConsole = "$ProfilePath\$ConsoleProfileName"
    $ProfilePathISE = "$ProfilePath\$ISEProfileName"

    $ConsolePath = "$Path\$ConsoleProfileName"
    $ISEPath = "$Path\$ISEProfileName"

    $CanCopyISE = $true
    $CanCopyConsole = $true
    if(!(Test-Path -Path $ConsolePath))
    {
        Write-Host "No Console Profile found in ExportPath. Make sure to save Profile first." -ForegroundColor Red
        $CanCopyConsole = $true
    }

    if(!(Test-Path -Path $ISEPath))
    {
        Write-Host "No ISE Profile found in ExportPath. Make sure to save Profile first." -ForegroundColor Red
        $CanCopyISE = $false
    }

    if($Force)
    {
        if($CanCopyISE -eq $true)
        {
            Copy-Item -Path $ISEPath -Destination $ProfilePathISE -Force
        }
        else 
        {
            break
        }
        if($CanCopyConsole -eq $true)
        {
            Copy-Item -Path $ConsolePath -Destination $ProfilePathConsole -Force
        }
        else 
        {
            break
        }
    }
    else
    {
        if($CanCopyISE -eq $true)
        {
            Copy-Item -Path $ISEPath -Destination $ProfilePathISE
        }
        else 
        {
            break
        }
        if($CanCopyConsole -eq $true)
        {
            Copy-Item -Path $ConsolePath -Destination $ProfilePathConsole
        }
        else 
        {
            break
        }
    }    
}

function New-PSProfile
{
    [CMDletBinding()]
    param
    (
        [Parameter()]
        [switch]$OnlyConsole,
        [Parameter()]
        [switch]$OnlyISE,
        [Parameter()]
        [switch]$Force
    )

    $Config = (Get-Content -Path ((Get-ItemProperty -Path HKLM:\Software\ProfileTools).psobject.properties.value[0]) | ConvertFrom-Json)
    
    $Path = $Config.ExportPath
    $ConsoleProfileName = $Config.ConsoleProfile
    $ISEProfileName = $Config.ISEProfile

    $ProfilePath = "$env:USERPROFILE\Documents\WindowsPowerShell\"
    $ProfilePathConsole = "$ProfilePath\$ConsoleProfileName"
    $ProfilePathISE = "$ProfilePath\$ISEProfileName"

    $ConsolePath = "$Path\$ConsoleProfileName"
    $ISEPath = "$Path\$ISEProfileName"

    if($Force)
    {
        if($OnlyConsole)
        {
            New-Item -Path $ProfilePathConsole -Force | Out-Null
        }
        elseif($OnlyISE)
        {
            New-Item -Path $ProfilePathISE -Force | Out-Null
        }
        else 
        {
            New-Item -Path $ProfilePathConsole -Force | Out-Null
            New-Item -Path $ProfilePathISE -Force | Out-Null
        }
    }
    else 
    {
        if($OnlyConsole)
        {
            New-Item -Path $ProfilePathConsole | Out-Null
        }
        elseif($OnlyISE)
        {
            New-Item -Path $ProfilePathISE | Out-Null
        }
        else 
        {
            New-Item -Path $ProfilePathConsole | Out-Null
            New-Item -Path $ProfilePathISE | Out-Null
        }
    }
}

function Save-PSProfile
{
    [CMDletBinding()]
    param
    (
        [Parameter()]
        [switch]$Force
    )

    $Config = (Get-Content -Path ((Get-ItemProperty -Path HKLM:\Software\ProfileTools).psobject.properties.value[0]) | ConvertFrom-Json)
    
    $Path = $Config.ExportPath
    $ConsoleProfileName = $Config.ConsoleProfile
    $ISEProfileName = $Config.ISEProfile

    $ProfilePath = "$env:USERPROFILE\Documents\WindowsPowerShell\"
    $ProfilePathConsole = "$ProfilePath\$ConsoleProfileName"
    $ProfilePathISE = "$ProfilePath\$ISEProfileName"

    $ConsolePath = "$Path\$ConsoleProfileName"
    $ISEPath = "$Path\$ISEProfileName"

    if($Force)
    {
        Copy-Item -Path $ProfilePathConsole -Destination $ConsolePath -Force
        Copy-Item -Path $ProfilePathISE -Destination $ISEPath -Force
    }
    else
    {
        Copy-Item -Path $ProfilePathConsole -Destination $ConsolePath
        Copy-Item -Path $ProfilePathISE -Destination $ISEPath
    }
}

function Edit-PSProfile
{
    [CMDletBinding(DefaultParameterSetName="Console")]
    param
    (
        [Parameter(ParameterSetName="Console")]
        [switch]$Console,
        [Parameter(ParameterSetName="ISE")]
        [switch]$ISE,
        [Parameter()]
        [switch]$Admin,
        [Parameter(ParameterSetName="All")]
        [switch]$All
    )

    $Config = (Get-Content -Path ((Get-ItemProperty -Path HKLM:\Software\ProfileTools).psobject.properties.value[0]) | ConvertFrom-Json)

    $Path = "$env:USERPROFILE\Documents\WindowsPowerShell\"
    $ConsoleProfileName = $Config.ConsoleProfile
    $ISEProfileName = $Config.ISEProfile

    $ConsoleProfilePath = "$Path\$ConsoleProfileName"
    $ISEProfilePath = "$Path\$ISEProfileName"

    if($ISE)
    {
        $Path = $ISEProfilePath
    }
    else
    {
        $Path = $ConsoleProfilePath
    }

    if($Admin)
    {
        if($All)
        {
            Start-Process -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" -ArgumentList "-File $ConsoleProfilePath" -Verb runAs
            Start-Process -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" -ArgumentList "-File $ISEProfilePath" -Verb runAs
        }
        else
        {
            Start-Process -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" -ArgumentList "-File $Path" -Verb runAs
        }
    }
    else
    {
        if($All)
        {
            Start-Process -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" -ArgumentList "-File $ConsoleProfilePath"
            Start-Process -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" -ArgumentList "-File $ISEProfilePath"
        }
        else
        {
            Start-Process -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" -ArgumentList "-File $Path"
        }
    }
}