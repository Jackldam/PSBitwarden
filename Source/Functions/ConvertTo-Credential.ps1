Function ConvertTo-Credential {
    <#
    .SYNOPSIS
    Converts plain text username and secure string password to a PSCredential object.

    .DESCRIPTION
    The ConvertTo-Credential function takes a plain text username and a secure string password 
    as input parameters and returns a PSCredential object. This object can be used in various 
    PowerShell cmdlets and functions that require authentication.

    .PARAMETER UserName
    The username in plain text.

    .PARAMETER Password
    The password as a secure string.

    .EXAMPLE
    $securePass = ConvertTo-SecureString "MyPassword" -AsPlainText -Force
    ConvertTo-Credential -UserName "MyUsername" -Password $securePass

    Creates a PSCredential object with the specified username and password.

    .NOTES
    Always ensure to handle PSCredential objects with care to maintain security.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $UserName,
        
        [Parameter(Mandatory)]
        [securestring]
        $Password
    )
    
    return New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $Password
}
