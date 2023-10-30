Function Install-PSBitwarden {
    <#
    .SYNOPSIS
    Installs the Bitwarden Command-Line Interface (CLI) on the system.

    .DESCRIPTION
    The Install-PSBitwarden function checks if the Bitwarden CLI is already installed. If not, it downloads and installs the CLI tool, ensuring that the tool is accessible from the system's PATH.

    .NOTES
    Ensure you have appropriate permissions to install software and modify system PATH.
    #>

    [CmdletBinding()]
    param ()

    #* Variables
    #region

    $local:ProgressPreference = "SilentlyContinue"
    $local:TempPath = "$env:TEMP"
    $local:installerPath = "C:\Users\$env:USERNAME\AppData\Roaming\CLI"

    #endregion

    #* Helper Functions
    #region

    Function New-Folder {
        [CmdletBinding()]
        param (
            [Parameter()]
            [string] $Path
        )

        if (!(Test-Path -Path $local:Path)) {
            New-Item -Path $local:Path -ItemType Directory -Force | Out-Null
        }
    }

    function Add-EnvPath {
        param(
            [Parameter(Mandatory = $true)]
            [string] $Path,

            [ValidateSet('Machine', 'User', 'Session')]
            [string] $Container = 'Session'
        )

        if ($Container -ne 'Session') {
            $containerMapping = @{
                Machine = [EnvironmentVariableTarget]::Machine
                User    = [EnvironmentVariableTarget]::User
            }
            $containerType = $containerMapping[$Container]
            $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
            if ($persistedPaths -notcontains $Path) {
                [Environment]::SetEnvironmentVariable('Path', ($persistedPaths + $Path) -join ';', $containerType)
            }
        }

        $envPaths = $env:Path -split ';'
        if ($envPaths -notcontains $Path) {
            $env:Path = ($envPaths + $Path) -join ';'
        }
    }

    #endregion

    #* Main script
    #region

    try {
        # Check if bw CLI is installed
        if (Test-Path -Path "$installerPath\bw.exe") { return }

        # Download required software
        $downloadUri = "https://vault.bitwarden.com/download/?app=cli&platform=windows"
        Invoke-WebRequest -UseBasicParsing -Uri $downloadUri -OutFile "$TempPath\bw.zip"

        # Install Commandline tools
        New-Folder -Path $installerPath
        Expand-Archive "$TempPath\bw.zip" -DestinationPath $installerPath -Force
        Add-EnvPath -Path $installerPath -Container User
    }
    catch {
        Write-Error "An error occurred while installing Bitwarden CLI: $_"
    }

    #endregion
}
