function Add-RocketCyberBaseUri {
<#
    .SYNOPSIS
        Sets the base URI for the RocketCyber API connection

    .DESCRIPTION
        The Add-RocketCyberBaseUri cmdlet sets the base URI which is later used
        to construct the full URI for all API calls

    .PARAMETER BaseUri
        Define the base URI for the RocketCyber API connection using
        RocketCyber's URI or a custom URI

    .PARAMETER DataCenter
        RocketCyber's URI connection point that can be one of the predefined data centers

        The accepted values for this parameter are:
        [ US, EU ]
        US = https://api-us.rocketcyber.com/v3
        EU = https://api-eu.rocketcyber.com/v3

    .EXAMPLE
        Add-RocketCyberBaseUri

        The base URI will use https://api-us.rocketcyber.com/v3 which is RocketCyber's default URI

    .EXAMPLE
        Add-RocketCyberBaseUri -DataCenter EU

        The base URI will use https://api-eu.rocketcyber.com/v3 which is RocketCyber's Europe URI

    .EXAMPLE
        Add-RocketCyberBaseUri -BaseUri http://myapi.gateway.celerium.org

        A custom API gateway of http://myapi.gateway.celerium.org will be used for
        all API calls to RocketCyber's API

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Add-RocketCyberBaseUri.html
#>

    [CmdletBinding()]
    [alias( "Add-RCBaseUri", "Set-RCBaseUri", "Set-RocketCyberBaseUri" )]
    Param (
        [Parameter(Mandatory = $false , ValueFromPipeline = $true)]
        [string]$BaseUri = 'https://api-us.rocketcyber.com/v3',

        [Parameter(Mandatory = $false) ]
        [ValidateSet( 'US', 'EU' )]
        [String]$DataCenter
    )

    begin {}

    process {

        if ($BaseUri[$BaseUri.Length-1] -eq "/") {
            $BaseUri = $BaseUri.Substring(0,$BaseUri.Length-1)
        }

        switch ($DataCenter) {
            'US' { $BaseUri = "https://api-us.rocketcyber.com/v3" }
            'EU' { $BaseUri = "https://api-eu.rocketcyber.com/v3" }
            Default {}
        }

        Set-Variable -Name 'RocketCyberModuleBaseURI' -Value $BaseUri -Option ReadOnly -Scope Global -Force

    }

    end {}
}