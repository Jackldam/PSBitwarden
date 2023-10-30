Function Get-PSBitwardenLogin {
    <#
    .SYNOPSIS
    Retrieves login items from Bitwarden, with an optional filter.

    .DESCRIPTION
    Queries Bitwarden for login items and allows for filtering based on a given criteria.

    .PARAMETER Filter
    A script block to filter Bitwarden login items. If not provided, all items are returned.

    .EXAMPLE
    Get-PSBitwardenLogin

    Returns all Bitwarden login items.

    .EXAMPLE
    Get-PSBitwardenLogin -Filter { $_.name -eq "mywebsite" }

    Returns login items with the name "mywebsite".

    .NOTES
    Requires the Bitwarden CLI (bw) to be installed and in the system's PATH.
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [scriptblock]
        $Filter
    )

    try {
        bw sync | Out-Null

        $BitwardenLogin = bw list items | ConvertFrom-Json

        $Properties = @(
            "id",
            "folderId",
            "organizationId",
            "name",
            "favorite",
            "type",
            @{Name = "Credential"; Expression = { ConvertTo-Credential -UserName $_.login.Username -Password ($_.login.Password | ConvertTo-SecureString -AsPlainText -Force) }},
            @{Name = "totp"; Expression = { $_.login.totp }},
            @{Name = "passwordRevisionDate"; Expression = { [datetime]$_.login.passwordRevisionDate }}
        )

        if ($Filter) {
            return ($BitwardenLogin | Where-Object $Filter | Select-Object $Properties)
        }
        else {
            return ($BitwardenLogin | Select-Object $Properties)
        }
    }
    catch {
        Write-Error "An error occurred while querying Bitwarden: $_"
    }
}
