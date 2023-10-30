Function Get-PSBitwardenFolder {
    <#
    .SYNOPSIS
    Retrieves Bitwarden folders based on given criteria.

    .DESCRIPTION
    The Get-PSBitwardenFolder function fetches folders from Bitwarden. If a folder name is provided, it returns the folder with the given name. If the -List switch is used, it returns all folders. The function outputs the folder's object ID and name.

    .PARAMETER FolderName
    The name of the folder to be retrieved from Bitwarden. This can be a simple name or a path-like structure (e.g., "Test/test").

    .PARAMETER List
    A switch parameter. When used, the function returns all folders from Bitwarden.

    .EXAMPLE
    Get-PSBitwardenFolder -FolderName Test

    Retrieves a folder named "Test" from Bitwarden and returns its object ID and name.

    .EXAMPLE
    Get-PSBitwardenFolder -List

    Retrieves all folders from Bitwarden and returns their object IDs and names.

    .NOTES
    Ensure that the Bitwarden CLI (bw) is installed and accessible from the system's PATH.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Folder')]
    param (
        [Parameter(ParameterSetName = 'Folder', Mandatory = $true)]
        [string]
        $FolderName,
        [Parameter(ParameterSetName = 'List', Mandatory = $true)]
        [switch]
        $List
    )

    begin {
        # Initialize any pre-requisites or validate module dependencies here
    }

    process {
        try {
            #Sync bitwarden prior to getting all folders
            bw sync | Out-Null
            $Result = (bw list folders | ConvertFrom-Json)

            if (!($List)) {
                #If list switch is used 
                $Result = $Result | Where-Object Name -EQ "$FolderName"
            }
        }
        catch {
        }

        return $Result
    }

    end {
        # Cleanup or final steps if needed
    }
}
