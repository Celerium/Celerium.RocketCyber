function Remove-RocketCyberModuleSettings {
<#
    .SYNOPSIS
        Removes the stored RocketCyber configuration folder

    .DESCRIPTION
        The Remove-RocketCyberModuleSettings cmdlet removes the RocketCyber folder and its files
        This cmdlet also has the option to remove sensitive RocketCyber variables as well

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\Celerium.RocketCyber

    .PARAMETER RocketCyberConfigPath
        Define the location of the RocketCyber configuration folder

        By default the configuration folder is located at:
            $env:USERPROFILE\Celerium.RocketCyber

    .PARAMETER AndVariables
        Define if sensitive RocketCyber variables should be removed as well

        By default the variables are not removed

    .EXAMPLE
        Remove-RocketCyberModuleSettings

        Checks to see if the default configuration folder exists and removes it if it does

        The default location of the RocketCyber configuration folder is:
            $env:USERPROFILE\Celerium.RocketCyber

    .EXAMPLE
        Remove-RocketCyberModuleSettings -RocketCyberConfigPath C:\Celerium.RocketCyber -AndVariables

        Checks to see if the defined configuration folder exists and removes it if it does
        If sensitive RocketCyber variables exist then they are removed as well

        The location of the RocketCyber configuration folder in this example is:
            C:\Celerium.RocketCyber

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Remove-RocketCyberModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess)]
    [alias("Remove-RCModuleSettings")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Destroy')]
        [string]$RocketCyberConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.RocketCyber"}else{".Celerium.RocketCyber"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'Destroy')]
        [switch]$AndVariables
    )

    begin {}

    process {

        if(Test-Path $RocketCyberConfigPath)  {

            Remove-Item -Path $RocketCyberConfigPath -Recurse -Force -WhatIf:$WhatIfPreference

            If ($AndVariables) {
                Remove-RocketCyberAPIKey
                Remove-RocketCyberBaseUri
            }

            if ($WhatIfPreference -eq $false) {

                if (!(Test-Path $RocketCyberConfigPath)) {
                    Write-Output "The Celerium.RocketCyber configuration folder has been removed successfully from [ $RocketCyberConfigPath ]"
                }
                else {
                    Write-Error "The Celerium.RocketCyber configuration folder could not be removed from [ $RocketCyberConfigPath ]"
                }

            }

        }
        else {
            Write-Warning "No configuration folder found at [ $RocketCyberConfigPath ]"
        }

    }

    end {}

}