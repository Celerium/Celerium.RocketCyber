function Get-RocketCyberApiKey {
<#
    .SYNOPSIS
        Gets the RocketCyber API key

    .DESCRIPTION
        The Get-RocketCyberApiKey cmdlet gets the RocketCyber API key
        global variable and returns it as a SecureString

    .PARAMETER AsPlainText
        Decrypt and return the API key in plain text

    .EXAMPLE
        Get-RocketCyberApiKey

        Gets the RocketCyber API key and returns it as a SecureString

    .EXAMPLE
        Get-RocketCyberApiKey -AsPlainText

        Gets and decrypts the API key from the global variable and
        returns the API key in plain text

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Get-RocketCyberApiKey.html
#>

    [CmdletBinding()]
    [alias( "Get-RCApiKey" )]
    Param (
        [Parameter(Mandatory = $false) ]
        [Switch]$AsPlainText
    )

    begin {}

    process {

        try {

            if ($RocketCyberModuleApiKey) {

                if ($AsPlainText) {
                    $ApiKey = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($RocketCyberModuleApiKey)
                    ( [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ApiKey) ).ToString()
                }
                else{$RocketCyberModuleApiKey}

            }
            else{
                Write-Warning 'The RocketCyber API key is not set. Run Add-RocketCyberApiKey to set the API key.'
            }
        }
        catch {
            Write-Error $_
        }
        finally {
            if ($ApiKey) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ApiKey)
            }
        }

    }

    end{}

}