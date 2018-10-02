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
        C:\PS> Install-PSProfileTools -ConfigPath "C:\Temp\" -ConfigName "ProfileSettings.json" -ExportPath "C:\Setup\Profile"

        .EXAMPLE
        C:\PS> Install-PSProfileTools -ExportPath "C:\Setup\Profile"
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
    <#
        .SYNOPSIS 
        Gets PSProfile from export path.      

        .DESCRIPTION
        Gets PSProfile from the export path saved in the Profile Config.

        .PARAMETER Force
        Automatically replaces existing Profiles.

        .EXAMPLE
        C:\PS> Get-PSProfile

        .EXAMPLE
        C:\PS> Get-PSProfile -Force
    #>
    [CMDletBinding()]
    param
    (
        [Parameter()]
        [switch]$Force
    )

   
    $Config = Get-PSProfileConfig
    
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
    <#
        .SYNOPSIS 
        Creates New PSProfile.

        .DESCRIPTION
        Creates empty PSProfile for Console and ISE.

        .PARAMETER OnlyConsole
        Only creates PSProfile for PS Console.

        .PARAMETER OnlyISE
        Only creates PSProfile for PS ISE.

        .PARAMETER Force
        Overrides existing PSProfile.

        .EXAMPLE
        C:\PS> New-PSProfile

        .EXAMPLE
        C:\PS> New-PSProfile -OnlyConsole

        .EXAMPLE
        C:\PS> New-PSProfile -OnlyISE -Force
    #>
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

    $Config = Get-PSProfileConfig
    
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
    <#
        .SYNOPSIS 
        Copies local PSProfile into ExportPath.

        .DESCRIPTION
        Copies local PSProfile into ExportPath.

        .PARAMETER Force
        Overrides existing PSProfile in ExportPath.

        .EXAMPLE
        C:\PS> Save-PSProfile

        .EXAMPLE
        C:\PS> Save-PSProfile -Force
    #>
    [CMDletBinding()]
    param
    (
        [Parameter()]
        [switch]$Force
    )

    $Config = Get-PSProfileConfig
    
    $Path = $Config.ExportPath
    $ConsoleProfileName = $Config.ConsoleProfile
    $ISEProfileName = $Config.ISEProfile

    $ProfilePath = "$env:USERPROFILE\Documents\WindowsPowerShell\"
    $ProfilePathConsole = "$ProfilePath\$ConsoleProfileName"
    $ProfilePathISE = "$ProfilePath\$ISEProfileName"

    $ConsolePath = "$Path\$ConsoleProfileName"
    $ISEPath = "$Path\$ISEProfileName"

    if(!(Test-Path -Path $ProfilePathISE))
        {
            Write-Host "No local ISE Profile found. Creating empty ISE Profile."
            New-Item -Path $ProfilePathISE | Out-Null
        }

        if(!(Test-Path -Path $ProfilePathConsole))
        {
            Write-Host "No local Console Profile found. Creating empty Console Profile."
            New-Item -Path $ProfilePathConsole | Out-Null
        }

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
    <#
        .SYNOPSIS 
        Opens PS ISE with PSProfile.

        .DESCRIPTION
        Opens PS ISE with PSProfile. Creates new one if no Profile exists.

        .PARAMETER Console
        Opens PS ISE with Console PSProfile. Default behaviour.

        .PARAMETER ISE
        Opens PS ISE with ISE PSProfile.

        .PARAMETER Admin
        Opens PS ISE with Console PSProfile as Admin. 

        .PARAMETER All
        Opens PS ISE with Console and ISE PSProfile.

        .EXAMPLE
        C:\PS> Edit-PSProfile

        .EXAMPLE
        C:\PS> Edit-PSProfile -ISE

        .EXAMPLE
        C:\PS> Edit-PSProfile -All

        .EXAMPLE
        C:\PS> Edit-PSProfile -All -Admin
    #>
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

    $Config = Get-PSProfileConfig

    $Path = "$env:USERPROFILE\Documents\WindowsPowerShell\"
    $ConsoleProfileName = $Config.ConsoleProfile
    $ISEProfileName = $Config.ISEProfile

    $ConsoleProfilePath = "$Path\$ConsoleProfileName"
    $ISEProfilePath = "$Path\$ISEProfileName"

    if($ISE)
    {
        $Path = $ISEProfilePath
        if(!(Test-Path -Path $ISEProfilePath))
        {
            Write-Host "No local ISE Profile found. Creating empty ISE Profile."
            New-Item -Path $ISEProfilePath | Out-Null
        }
    }
    else
    {
        $Path = $ConsoleProfilePath
        if(!(Test-Path -Path $ConsoleProfilePath))
        {
            Write-Host "No local Console Profile found. Creating empty Console Profile."
            New-Item -Path $ConsoleProfilePath | Out-Null
        }
    }

    if($All)
    {
        if(!(Test-Path -Path $ISEProfilePath))
        {
            Write-Host "No local ISE Profile found. Creating empty ISE Profile."
            New-Item -Path $ISEProfilePath | Out-Null
        }

        if(!(Test-Path -Path $ConsoleProfilePath))
        {
            Write-Host "No local Console Profile found. Creating empty Console Profile."
            New-Item -Path $ConsoleProfilePath | Out-Null
        }
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

function Get-PSProfileConfig
{
    if(!(Test-Path -Path HKLM:\Software\ProfileTools))
    {
        Write-Host "PSProfileConfig not found. Create a Config with command 'Install-PSProfileTools'." -ForegroundColor Red
        break
    }

    if(!(Test-Path -Path ((Get-ItemProperty -Path HKLM:\Software\ProfileTools).psobject.properties.value[0])))
    {
        Write-Host "PSProfileConfig not found. Create a Config with command 'Install-PSProfileTools'." -ForegroundColor Red
        break
    }

    $PSProfileConfig = (Get-Content -Path ((Get-ItemProperty -Path HKLM:\Software\ProfileTools).psobject.properties.value[0]) | ConvertFrom-Json)

    return $PSProfileConfig
}