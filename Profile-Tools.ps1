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

function Edit-PSProfile
{
    [CMDletBinding(DefaultParameterSetName="Version")]
    param
    (
        [Parameter()]
        [string]$Path = "$env:USERPROFILE\Documents\WindowsPowerShell\",
        [Parameter(ParameterSetName="ISE")]
        [switch]$ISE,
        [Parameter()]
        [switch]$Admin,
        [Parameter(ParameterSetName="All")]
        [switch]$All
    )

    $ConsoleProfileName = "Microsoft.PowerShell_profile.ps1"
    $ISEProfileName = "Microsoft.PowerShellISE_profile.ps1"

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