function Get-RocketCyberBaseUri {
<#
    .SYNOPSIS
        Shows the RocketCyber base URI global variable

    .DESCRIPTION
        The Get-RocketCyberBaseUri cmdlet shows the RocketCyber base URI global variable value

    .EXAMPLE
        Get-RocketCyberBaseUri

        Shows the RocketCyber base URI global variable value

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Get-RocketCyberBaseUri.html
#>

    [CmdletBinding()]
    [alias("Get-RCBaseUri")]
    Param ()

    begin {}

    process {

        switch ([bool]$RocketCyberModuleBaseURI) {
            $true   { $RocketCyberModuleBaseURI }
            $false  { Write-Warning "The RocketCyber base URI is not set. Run Add-RocketCyberBaseUri to set the base URI." }
        }

    }

    end {}
}