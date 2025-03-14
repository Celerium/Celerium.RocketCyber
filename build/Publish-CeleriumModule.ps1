<#
.NOTES
    Copyright 1990-2024 Celerium

    NAME: Publish-CeleriumModule.ps1
    Type: PowerShell

        AUTHOR:  David Schulte
        DATE:    2023-09-11
        EMAIL:   celerium@celerium.org
        Updated: 2023-09-16

    TODO:

.SYNOPSIS
    Publishes a PowerShell module to the PowerShell Gallery

.DESCRIPTION
    The Publish-CeleriumModule script publishes a PowerShell module
    to the PowerShell Gallery

.PARAMETER ModuleName
    The name of the module to update help docs for

    Default value: Celerium.RocketCyber

.PARAMETER version
    The build version to publish

.PARAMETER NuGetApiKey
    The PowerShell Gallery NuGetApiKey with permissions to
    publish modules

.EXAMPLE
    .\Publish-CeleriumModule.ps1 -Version 1.0.0 -NuGetApiKey 12345 -WhatIf -Verbose

    Shows what will happen if a module is pushed to the PowerShell Gallery

.EXAMPLE
    .\Publish-CeleriumModule.ps1 -Version 1.0.0 -NuGetApiKey 12345 -Verbose

    Publishes a PowerShell module to the PowerShell Gallery

.INPUTS
    N\A

.OUTPUTS
    N\A

.LINK
    https://celerium.org

#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$ModuleName = 'Celerium.RocketCyber',

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Version,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$NuGetApiKey

)

begin {

    if ($IsWindows -or $PSEdition -eq 'Desktop') {
        $RootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\build', [System.StringComparison]::OrdinalIgnoreCase)) )"
    }
    else{
        $RootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('/build', [System.StringComparison]::OrdinalIgnoreCase)) )"
    }

    $ModulePath = Join-Path -Path $RootPath -ChildPath "\build\$ModuleName\$Version"
    $ModulePsd1 = Join-Path -Path $ModulePath -ChildPath "$ModuleName.psd1"

}

process {

    try {

        if ( $($Test = Test-ModuleManifest -Path $ModulePsd1 -ErrorAction SilentlyContinue; $?) ) {

            $publish_Params = @{
                Path        = $ModulePath
                NuGetApiKey = $NuGetApiKey
                WhatIf      = $WhatIfPreference
            }

            Publish-Module @publish_Params

        }
        else{
            throw "The [ $ModuleName ] module failed Test-ModuleManifest"
            Write-Error $_
        }

    }
    catch {
        Write-Error $_
        exit 1
    }

}

end {}