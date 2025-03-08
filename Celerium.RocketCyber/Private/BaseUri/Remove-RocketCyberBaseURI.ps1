function Remove-RocketCyberBaseUri {
<#
    .SYNOPSIS
        Removes the RocketCyber base URI global variable

    .DESCRIPTION
        The Remove-RocketCyberBaseUri cmdlet removes the RocketCyber base URI global variable

    .EXAMPLE
        Remove-RocketCyberBaseUri

        Removes the RocketCyber base URI global variable

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Remove-RocketCyberBaseUri.html
#>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    [alias("Remove-RCBaseUri")]
    Param ()

    begin {}

    process {

        switch ([bool]$RocketCyberModuleBaseURI) {
            $true   {
                if ($PSCmdlet.ShouldProcess('RocketCyberModuleBaseURI')) {
                    Remove-Variable -Name "RocketCyberModuleBaseURI" -Scope Global -Force
                }
            }
            $false  { Write-Warning "The RocketCyber base URI variable is not set. Nothing to remove" }
        }

    }

    end {}

}