# PSProfile-Tools

Administration Tool for your PowerShell Profile.  
The PowerShell Profile allows you to write Code that will be loaded every time you open the PS Console or ISE.  
It's a great way to always have your own functions ready, without having the need to code and import an entire module.  
This module will give you an easy way to create and backup your PS profile, in case you switch to another machine.

#### Sidenote

*The more code you put into your profile the longer it will take for the PS Console and/or ISE to start.*

## Installation

[PowerShell Gallery](https://www.powershellgallery.com/packages/PSProfile-Tools)

Run the following command in an elevated PowerShell session to install the PSProfile-Tools cmdlets:

```powershell
Install-Module -Name PSProfile-Tools
```

To update to the latest Version run following command:
```powershell
Update-Module -Name PSProfile-Tools
```

## Usage

NOTE: If no profile exists, empty Profiles will be created for you.

```powershell
Import-Module -Name PSProfile-Tools

#Neccessary at first installation
Install-PSProfileTools -ExportPath "Path\To\Export"

#If you have no PSProfile so far run
New-PSProfile

#To save your profile run
Save-PSProfile

#To edit your profile run
Edit-PSProfile
```

## License
[MIT](https://github.com/MaxBelohoubek/PSProfile/blob/master/LICENSE.md)