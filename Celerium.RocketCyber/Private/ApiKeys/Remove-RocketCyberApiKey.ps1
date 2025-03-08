function Remove-RocketCyberApiKey {
<#
    .SYNOPSIS
        Removes the RocketCyber API key

    .DESCRIPTION
        The Remove-RocketCyberApiKey cmdlet removes the RocketCyber API key

    .EXAMPLE
        Remove-RocketCyberApiKey

        Removes the RocketCyber API key

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Remove-RocketCyberApiKey.html
#>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    [alias("Remove-RCApiKey")]
    Param ()

    begin {}

    process {

        switch ([bool]$RocketCyberModuleApiKey) {
            $true   {
                if ($PSCmdlet.ShouldProcess('RocketCyberModuleApiKey')) {
                    Remove-Variable -Name 'RocketCyberModuleApiKey' -Scope Global -Force
                }
            }
            $false  { Write-Warning "The RocketCyber API key variable is not set. Nothing to remove" }
        }

    }

    end{}

}