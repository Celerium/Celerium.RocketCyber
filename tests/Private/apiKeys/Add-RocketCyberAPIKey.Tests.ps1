<#
    .SYNOPSIS
        Pester tests for the Celerium.RocketCyber APIKeys functions

    .DESCRIPTION
        Pester tests for the Celerium.RocketCyber APIKeys functions

    .PARAMETER ModuleName
        The name of the local module to import

    .PARAMETER Version
        The version of the local module to import

    .PARAMETER buildTarget
        Which version of the module to run tests against

        Allowed values:
            'Built', 'NotBuilt'

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\APIKeys\Get-RocketCyberAPIKey.Tests.ps1

        Runs a pester test and outputs simple results

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\APIKeys\Get-RocketCyberAPIKey.Tests.ps1 -Output Detailed

        Runs a pester test and outputs detailed results

    .INPUTS
        N\A

    .OUTPUTS
        N\A

    .NOTES
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

#Available in Discovery & Run
[CmdletBinding()]
param (
    [Parameter(Mandatory = $false) ]
    [ValidateNotNullOrEmpty()]
    [String]$ModuleName = 'Celerium.RocketCyber',

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Version,

    [Parameter(Mandatory=$true)]
    [ValidateSet('Built','NotBuilt')]
    [string]$BuildTarget
)

#EndRegion  [ Parameters ]

#Region     [ Prerequisites ]

#Available inside It but NOT Describe or Context
    BeforeAll {

        if ($IsWindows -or $PSEdition -eq 'Desktop') {
            $RootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\tests', [System.StringComparison]::OrdinalIgnoreCase)) )"
        }
        else{
            $RootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('/tests', [System.StringComparison]::OrdinalIgnoreCase)) )"
        }

        switch ($BuildTarget) {
            'Built'     { $ModulePath = Join-Path -Path $RootPath -ChildPath "\build\$ModuleName\$Version" }
            'NotBuilt'  { $ModulePath = Join-Path -Path $RootPath -ChildPath "$ModuleName" }
        }

        if (Get-Module -Name $ModuleName) {
            Remove-Module -Name $ModuleName -Force
        }

        $ModulePsd1 = Join-Path -Path $ModulePath -ChildPath "$ModuleName.psd1"

        Import-Module -Name $ModulePsd1 -ErrorAction Stop -ErrorVariable moduleError *> $null


        if ($ModuleError) {
            $ModuleError
            exit 1
        }

    }

    AfterAll{

        Remove-RocketCyberAPIKey -WarningAction SilentlyContinue

        if (Get-Module -Name $ModuleName) {
            Remove-Module -Name $ModuleName -Force
        }

    }

#Available in Describe and Context but NOT It
#Can be used in [ It ] with [ -TestCases @{ VariableName = $VariableName } ]
    BeforeDiscovery{

        $PesterTestName = (Get-Item -Path $PSCommandPath).Name
        $CommandName = $PesterTestName -replace '.Tests.ps1',''

    }

#EndRegion  [ Prerequisites ]


Describe "Testing the [ $BuildTarget ] version of [ $CommandName ] functions with [ $PesterTestName ]" -Tag @('APIKeys') {

    Context "[ $CommandName ] testing functions" {

        It "[ $CommandName ] should have an alias" {
            Get-Alias -Name Set-RCAPIKey | Should -BeTrue
            Get-Alias -Name Add-RCAPIKey | Should -BeTrue
            Get-Alias -Name Set-RocketCyberAPIKey | Should -BeTrue
        }

        It "[ -ApiKey ] should accept a value from the pipeline" {
            "Celerium.RocketCyberKey" | Add-RocketCyberAPIKey
            Get-RocketCyberAPIKey | Should -Not -BeNullOrEmpty
        }

        It "[ -ApiKey ] should accept input" {
            Add-RocketCyberAPIKey -ApiKey '12345'
            Get-RocketCyberAPIKey | Should -Not -BeNullOrEmpty
        }

    }

}