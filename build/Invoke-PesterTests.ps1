<#
.NOTES
    Copyright 1990-2024 Celerium

    NAME: Invoke-PesterTests.ps1
    Type: PowerShell

        AUTHOR:  David Schulte
        DATE:    2023-04-1
        EMAIL:   celerium@Celerium.org
        Updated: 2023-09-16

    TODO:
    Add public function testing with secrets

.SYNOPSIS
    Invoke Pester tests against all functions in a module

.DESCRIPTION
    Invoke Pester tests against all functions in a module

.PARAMETER ModuleName
    The name of the local module to import

    Default value: Celerium.RocketCyber

.PARAMETER Version
    The version of the local module to import

.PARAMETER IncludeTag
    Tags to run tests against

.PARAMETER ExcludeTag
    Tags associated to test to skip

.PARAMETER buildTarget
    Which version of the module to run tests against

    Allowed values:
        'Built', 'NotBuilt'

.PARAMETER Output
    How detailed should the pester output be

    Default value: Normal

    Allowed values:
        'Detailed', 'Diagnostic', 'Minimal', 'None', 'Normal'


.EXAMPLE
    .\Invoke-PesterTests -ModuleName Celerium.RocketCyber -Version 1.2.3

    Runs various pester tests against all functions in the module
    and outputs the results to the console

    An XML of the tests is also output to the build directory

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
#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.5.0' }

#Region     [ Parameters ]

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false) ]
    [ValidateNotNullOrEmpty()]
    [string]$ModuleName = 'Celerium.RocketCyber',

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Version,

    [Parameter(Mandatory=$false)]
    [string[]]$IncludeTag = @(),

    [Parameter(Mandatory=$false)]
    [string[]]$ExcludeTag = 'PLACEHOLDER',

    [Parameter(Mandatory=$false)]
    [ValidateSet('Built','NotBuilt')]
    [string]$BuildTarget = 'NotBuilt',

    [Parameter(Mandatory=$false)]
    [ValidateSet('Detailed', 'Diagnostic', 'Minimal', 'None', 'Normal')]
    [string]$output = 'Normal'
)

#EndRegion  [ Parameters ]

#Region     [ Prerequisites ]

try {

    if ($IsWindows -or $PSEdition -eq 'Desktop') {
        $RootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\build', [System.StringComparison]::OrdinalIgnoreCase)) )"
    }
    else{
        $RootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('/build', [System.StringComparison]::OrdinalIgnoreCase)) )"
    }

    switch ($BuildTarget) {
        'Built'     { $ModulePath = Join-Path -Path $RootPath -ChildPath "\build\$ModuleName\$Version" }
        'NotBuilt'  { $ModulePath = Join-Path -Path $RootPath -ChildPath "$ModuleName" }
    }

    $testPath = Join-Path -Path $RootPath -ChildPath "tests"

    #$withoutAuth = $( [bool]$ApiKey_Public -eq $false -or [bool]$ApiKey_Secret -eq $false )

}
catch {
    Write-Error $_
    exit 1
}

#EndRegion  [ Prerequisites ]

#Region     [ Pester Configuration ]

$pesterContainer_params = @{
    'ModuleName'        = $ModuleName;
    'version'           = $Version;
    'buildTarget'       = $BuildTarget
}
    $pester_Container = New-PesterContainer -Path $testPath -Data $pesterContainer_params

$pester_Options = @{

    Run = @{
        Container = $pester_Container
        PassThru = $true
    }

    Filter = @{
        Tag = $IncludeTag
        ExcludeTag = $ExcludeTag
    }

    TestResult = @{
        Enabled = $true
        OutputFormat = 'NUnitXml'
        OutputPath = Join-Path -Path . -ChildPath "build\$($ModuleName)_$($BuildTarget)_Results.xml"
        OutputEncoding = 'UTF8'
    }

    Should = @{
        ErrorAction = 'Continue'
    }

    Output = @{
        Verbosity = $output
    }

}

    $pester_Configuration = New-PesterConfiguration -Hashtable $pester_Options

#EndRegion  [ Pester Configuration ]

#Region     [ Pester Invoke ]

$pester_Results = Invoke-Pester -Configuration $pester_Configuration
    Set-Variable -Name Invoke_PesterResults -Value $pester_Results -Scope Global -Force

#EndRegion  [ Pester Invoke ]

