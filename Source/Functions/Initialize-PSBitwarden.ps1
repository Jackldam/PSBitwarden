Function Initialize-PSBitwarden {
    <#
    .SYNOPSIS
    Initialize a Bitwarden session using either credentials or an API key.

    .DESCRIPTION
    The Initialize-PSBitwarden function configures a Bitwarden server and initializes a session using 
    either user credentials or an API key. The function ensures that either credentials or an API key 
    are provided, but not both.

    .PARAMETER Credential
    User credentials required for login. Either Credential or ApiKey must be provided, but not both.

    .PARAMETER ApiKey
    API key required for login. Either Credential or ApiKey must be provided, but not both.

    .PARAMETER Server
    Optional parameter specifying the Bitwarden server to configure.

    .EXAMPLE
    Initialize-PSBitwarden -Credential $myCred -Server 'https://myserver.com'

    Configures the Bitwarden server to 'https://myserver.com' and initializes a session using the provided credentials.

    .EXAMPLE
    Initialize-PSBitwarden -ApiKey $myApiKey

    Initializes a Bitwarden session using the provided API key.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Credential')]
    param (
        [Parameter(ParameterSetName = 'Credential', Mandatory = $true)]
        [pscredential]
        $Credential,
        
        [Parameter(ParameterSetName = 'ApiKey', Mandatory = $true)]
        [string]
        $ClientId,

        [Parameter(ParameterSetName = 'ApiKey', Mandatory = $true)]
        [string]
        $ClientSecret,
        
        [Parameter()]
        [string]
        $Server
    )

    begin {
        # Initialize any pre-requisites or validate module dependencies here
    }

    process {
        try {
            if ($Server) {
                bw config server $Server | Out-Null
            }

            if ($PSCmdlet.ParameterSetName -eq 'Credential') {
                
                $BW_SESSION = (bw login $Credential.UserName $Credential.GetNetworkCredential().Password --raw)
                $env:BW_SESSION = $BW_SESSION
                [System.Environment]::SetEnvironmentVariable('BW_SESSION', "$BW_SESSION" , 'User')
            }
            else {
                $env:BW_CLIENTID = $ClientId
                $env:BW_CLIENTSECRET = $ClientSecret
                $local:bwlogin = bw login --apikey
            }

            if (($BW_SESSION) -or ($bwlogin)) {
                Write-Output "Login successful"
            }
            else {
                throw "Login failed!"
            }
        }
        catch {
            throw $_
        }
    }

    end {
        # Cleanup or final steps if needed
    }
}
