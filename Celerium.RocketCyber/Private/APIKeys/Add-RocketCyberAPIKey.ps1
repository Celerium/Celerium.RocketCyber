function Add-RocketCyberAPIKey {
<#
    .SYNOPSIS
        Sets your API key used to authenticate all API calls

    .DESCRIPTION
        The Add-RocketCyberAPIKey cmdlet sets your API key which is used to
        authenticate all API calls made to RocketCyber. Once the API key is
        defined, it is encrypted using SecureString

        The RocketCyber API keys are generated via the RocketCyber web interface
        at Provider Settings > RocketCyber API

    .PARAMETER ApiKey
        Plain text API key

        If not defined the cmdlet will prompt you to enter the API key which
        will be stored as a SecureString

    .PARAMETER ApiKeySecureString
        Input a SecureString object containing the API key

    .EXAMPLE
        Add-RocketCyberAPIKey

        Prompts to enter in the API key

    .EXAMPLE
        Add-RocketCyberAPIKey -ApiKey 'your_ApiKey'

        The RocketCyber API will use the string entered into the [ -ApiKey ] parameter

    .EXAMPLE
        '12345' | Add-RocketCyberAPIKey

        The Add-RocketCyberAPIKey function will use the string passed into it as its API key

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Add-RocketCyberAPIKey.html
#>

    [CmdletBinding()]
    [alias( "Add-RCAPIKey", "Set-RCAPIKey", "Set-RocketCyberAPIKey" )]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'AsPlainText')]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'SecureString')]
        [ValidateNotNullOrEmpty()]
        [securestring]$ApiKeySecureString
    )

    begin {}

    process {

        switch ($PSCmdlet.ParameterSetName) {

            'AsPlainText' {

                if ($ApiKey) {
                    $SecureString = ConvertTo-SecureString $ApiKey -AsPlainText -Force

                    Set-Variable -Name "RocketCyberModuleApiKey" -Value $SecureString -Option ReadOnly -Scope global -Force
                }
                else {
                    Write-Output "Please enter your API key:"
                    $SecureString = Read-Host -AsSecureString

                    Set-Variable -Name "RocketCyberModuleApiKey" -Value $SecureString -Option ReadOnly -Scope global -Force
                }

            }

            'SecureString' { Set-Variable -Name "RocketCyberModuleApiKey" -Value $ApiKeySecureString -Option ReadOnly -Scope global -Force }

        }

    }

    end {}
}