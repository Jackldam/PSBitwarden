# PSBitwarden.Tests.ps1

# Import the module you're testing
Import-Module -Name 'C:\Users\jackdenouden\OneDrive - KPMG\Desktop\MySetup\PSBitwarden\PSBitwarden'

Describe 'PSBitwarden Tests' {

    Context 'Install-PSBitwarden' {

        It 'Should create a folder in the appdata folder of the end-user called CLI' {
            Install-PSBitwarden
            $result = Test-Path -Path "$Env:APPDATA\CLI\bw.exe"
            $result | Should -Be $true
        }
    }

    Context 'ConvertTo-Credential' {
        
        It 'Should return a PSCredential object' {
            $securePass = ConvertTo-SecureString "MyPassword" -AsPlainText -Force
            $result = ConvertTo-Credential -UserName "MyUsername" -Password $securePass
            $result | Should -BeOfType [System.Management.Automation.PSCredential]
        }

        It 'Should have the correct username' {
            $securePass = ConvertTo-SecureString "MyPassword" -AsPlainText -Force
            $result = ConvertTo-Credential -UserName "MyUsername" -Password $securePass
            $result.UserName | Should -BeExactly "MyUsername"
        }
    }

    Context 'Get-PSBitwardenFolder' {
        
        # This is a bit tricky since you're interacting with an external tool.
        # For real testing, you'd likely want to mock the behavior of `bw` to avoid actual calls.
        # Here's a simple test without mocking:

        It 'Should return an object when -List is used' {
            $result = Get-PSBitwardenFolder -List
            $result | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Get-PSBitwardenLogin' {

        It 'Should return an object' {
            $result = Get-PSBitwardenLogin
            $result | Should -Not -BeNullOrEmpty
        }
    }

    # Add other Context blocks for other functions...
}
