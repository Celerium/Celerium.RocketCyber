<#
.NOTES
    Copyright 1990-2024 Celerium

    NAME: Invoke-ModuleBuild.ps1
    Type: PowerShell

        AUTHOR:  David Schulte
        DATE:    2023-04-1
        EMAIL:   celerium@Celerium.org
        Updated: 2023-09-16

    TODO:

.SYNOPSIS
    Builds & prepares a PowerShell module for deployment

.DESCRIPTION
    The Invoke-ModuleBuild.ps1 script builds & prepares a PowerShell
    module for deployment

.PARAMETER ModuleName
    The name of the module to build

    Example: Celerium.RocketCyber

.PARAMETER Version
    The module version (must be a valid System.Version such as PowerShell supports for modules)

.PARAMETER UnversionedOutputDirectory
    Overrides the VersionedOutputDirectory, producing an OutputDirectory without a version number as the last folder

.EXAMPLE
    .\Invoke-ModuleBuild.ps1 -Version 1.2.3

    Compiles the module files located in ..\ModuleName and builds
    a combined module in ...\build\ModuleName\1.2.3

.INPUTS
    N\A

.OUTPUTS
    N\A

.LINK
    https://celerium.org

#>

<############################################################################################
                                        Code
############################################################################################>
#Requires -Version 5.1
#Requires -Modules @{ ModuleName="ModuleBuilder";   ModuleVersion="3.1.0" }
#Requires -Modules @{ ModuleName="Pester";          ModuleVersion="5.5.0" }
#Requires -Modules @{ ModuleName="platyPS";         ModuleVersion="0.14.2" }

#Region  [ Parameters ]

[CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [string]$ModuleName = 'Celerium.RocketCyber',

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Version,

        [Parameter(Mandatory=$false)]
        [Switch]$UnversionedOutputDirectory
    )

#EndRegion  [ Parameters ]

Write-Verbose ''
Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm) - [ $($PSCmdlet.ParameterSetName) ]"
Write-Verbose ''

#Region     [ Prerequisites ]

$StartDate = Get-Date

#EndRegion  [ Prerequisites ]

#Region     [ Build Module ]

try {

    if ($IsWindows -or $PSEdition -eq 'Desktop') {
        $RootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\build', [System.StringComparison]::OrdinalIgnoreCase)) )"
    }
    else{
        $RootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('/build', [System.StringComparison]::OrdinalIgnoreCase)) )"
    }

    $ModulePath         = Join-Path -Path $RootPath -ChildPath $ModuleName
    $SourcePath         = Join-Path -Path $ModulePath -ChildPath "$ModuleName.psd1"
    $OutputDirectory    = Join-Path -Path $RootPath -ChildPath "build"

    $params = @{
        SourcePath      = $SourcePath
        OutputDirectory = $OutputDirectory
        Version         = $Version
        PublicFilter    = Join-Path -Path 'Private','Public' -ChildPath "*.ps1"
        UnversionedOutputDirectory = $UnversionedOutputDirectory
    }

    Build-Module @params -Verbose

    #Replace & comment out NestedModules from nonBuilt module
    $ModulePath_Built = Join-Path -Path $OutputDirectory -ChildPath "$ModuleName\$Version\$ModuleName.psd1"

    Update-Metadata -Path $ModulePath_Built -PropertyName NestedModules -Value  @()
    (Get-Content -Path $ModulePath_Built -Raw) -replace 'NestedModules = @\(\)', '# NestedModules = @()' | Set-Content -Path $ModulePath_Built

}
catch {
    Write-Error $_
    exit 1
}

#EndRegion  [ Build Module ]

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''

$TimeToComplete = New-TimeSpan -Start $StartDate -End (Get-Date)
Write-Verbose 'Time to complete'
Write-Verbose ($TimeToComplete | Select-Object * -ExcludeProperty Ticks,Total*,Milli* | Out-String)