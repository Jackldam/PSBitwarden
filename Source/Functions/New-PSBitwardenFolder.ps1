Function New-PSBitwardenFolder {
    <#
    .SYNOPSIS
    Creates a new Bitwarden folder.

    .DESCRIPTION
    The New-PSBitwardenFolder function creates a new folder in Bitwarden using the provided folder name. 
    The function then returns the folder's object ID and name.

    .PARAMETER FolderName
    The name of the folder to be created in Bitwarden. This can be a simple name or a path-like structure (e.g., "Test/test").

    .EXAMPLE
    New-PSBitwardenFolder -FolderName Test

    Creates a folder named "Test" in Bitwarden and returns its object ID and name.

    .EXAMPLE
    New-PSBitwardenFolder -FolderName Test/test

    Creates a folder with a path-like structure "Test/test" in Bitwarden and returns its object ID and name.

    .NOTES
    Ensure that the Bitwarden CLI (bw) is installed and accessible from the system's PATH.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Folder')]
    param (
        [Parameter(ParameterSetName = 'Folder', Mandatory = $true)]
        [string]
        $FolderName
    )

    begin {
        # Initialize any pre-requisites or validate module dependencies here
    }

    process {
        try {
            $Json = [PSCustomObject]@{
                name = $FolderName
            } | ConvertTo-Json -Compress
            
            $json | bw encode | bw create folder | ConvertFrom-Json
        }
        catch {
            throw $_
        }
    }

    end {
        # Cleanup or final steps if needed
    }
}