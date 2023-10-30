# PSBitwarden

A PowerShell module designed to facilitate interactions with the Bitwarden Command-Line Interface (CLI).

## Overview

PSBitwarden provides a series of cmdlets to make it easier for administrators and users to manage their Bitwarden vault, sync data, manage folders, and more, all from the comfort of their PowerShell session.

## Features

- Initialize a Bitwarden session using either user credentials or an API key.
- Retrieve login items from Bitwarden, with optional filtering.
- Install the Bitwarden CLI on your system.
- Retrieve Bitwarden folders based on given criteria.
- Convert plain text username and secure string password to a PSCredential object.
- Create new folders in your Bitwarden vault.

## Getting Started

1. **Install the Module**: Clone this repository or download the module to your local machine.
2. **Import the Module**: Use `Import-Module ./path_to_module/PSBitwarden` to import the module into your PowerShell session.
3. **Use the Cmdlets**: Start using the cmdlets as per your requirement. For detailed instructions on each cmdlet, use `Get-Help CmdletName`.

## Examples

```powershell
# Initialize Bitwarden with user credentials
Initialize-PSBitwarden -Credential $myCred

# Retrieve all Bitwarden login items
Get-PSBitwardenLogin

# Create a new folder in Bitwarden
New-PSBitwardenFolder -FolderName "NewFolder"
