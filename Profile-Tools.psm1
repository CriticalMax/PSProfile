function Install-ProfileTools
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

    if($Force)
    {
        Copy-Item -Path $ConsolePath -Destination $ProfilePathConsole -Force
        Copy-Item -Path $ISEPath -Destination $ProfilePathISE -Force
    }
    else
    {
        Copy-Item -Path $ConsolePath -Destination $ProfilePathConsole
        Copy-Item -Path $ISEPath -Destination $ProfilePathISE
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