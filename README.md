# PSProfile-Tools

Administration Tool for your PowerShell Profile.

## Installation

[PowerShell Gallery](https://www.powershellgallery.com/packages/PSProfile-Tools/)

Run the following command in an elevated PowerShell session to install the PSProfile-Tools cmdlets:

```powershell
Install-Module -Name PSProfile-Tools
```

To update to the latest Version run following command:
```powershell
Update-Module -Name PSProfile-Tools
```

## Usage

NOTE: You need an already exisiting PowerShell Profile (Console and ISE Version)  
NOTE: This will be fixed in a coming release.

```powershell
Import-Module -Name PSProfile-Tools

#Necessary at first installation
Install-PSProfileTools -ExportPath "Path\To\Export"

#To save your profile run
Save-PSProfile

#To edit your profile run
Edit-PSProfile
```
