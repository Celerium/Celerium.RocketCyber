function Test-RocketCyberAPIKey {
<#
    .SYNOPSIS
        Test the RocketCyber API key

    .DESCRIPTION
        The Test-RocketCyberAPIKey cmdlet tests the base URI & API
        key that was defined in the
        Add-RocketCyberBaseUri & Add-RocketCyberAPIKey cmdlets

    .PARAMETER BaseUri
        Define the base URI for the RocketCyber API connection using RocketCyber's URI or a custom URI

        The default base URI is https://api-us.rocketcyber.com/v3

    .PARAMETER id
        Data will be retrieved from this account id

    .EXAMPLE
        Test-RocketCyberBaseUri -id 12345

        Tests the base URI & API key that was defined in the
        Add-RocketCyberBaseUri & Add-RocketCyberAPIKey cmdlets

        The default full base uri test path is:
            https://api-us.rocketcyber.com/v3/account/id

    .EXAMPLE
        Test-RocketCyberBaseUri -BaseUri http://myapi.gateway.celerium.org -id 12345

        Tests the base URI & API key that was defined in the
        Add-RocketCyberBaseUri & Add-RocketCyberAPIKey cmdlets

        The full base uri test path in this example is:
            http://myapi.gateway.celerium.org/id

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Test-RocketCyberAPIKey.html
#>

    [CmdletBinding()]
    [alias("Test-RCAPIKey")]
    Param (
        [Parameter(Mandatory = $false) ]
        [string]$BaseUri = $RocketCyberModuleBaseURI
    )

    begin { $ResourceUri = "/account" }

    process {

        Write-Verbose "Testing API key against [ $($BaseUri + $ResourceUri) ]"

        try {

            $ApiToken = Get-RocketCyberAPIKey -AsPlainText

            $RocketCyberHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
            $RocketCyberHeaders.Add("Content-Type", 'application/json')
            $RocketCyberHeaders.Add('Authorization', "Bearer $ApiToken")

            $rest_output = Invoke-WebRequest -Method Get -Uri ($BaseUri + $ResourceUri) -Headers $RocketCyberHeaders -ErrorAction Stop
        }
        catch {

            [PSCustomObject]@{
                Method              = $_.Exception.Response.Method
                StatusCode          = $_.Exception.Response.StatusCode.value__
                StatusDescription   = $_.Exception.Response.StatusDescription
                Message             = $_.Exception.Message
                URI                 = $($BaseUri + $ResourceUri)
            }

        } finally {
            Remove-Variable -Name 'RocketCyberHeaders' -Force
        }

        if ($rest_output) {
            $data = @{}
            $data = $rest_output

            [PSCustomObject]@{
                StatusCode          = $data.StatusCode
                StatusDescription   = $data.StatusDescription
                URI                 = $($BaseUri + $ResourceUri)
            }
        }

    }

    end {}

}