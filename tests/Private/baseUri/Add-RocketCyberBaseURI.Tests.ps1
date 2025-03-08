<#
    .SYNOPSIS
        Pester tests for the Celerium.RocketCyber BaseUri functions

    .DESCRIPTION
        Pester tests for the Celerium.RocketCyber BaseUri functions

    .PARAMETER ModuleName
        The name of the local module to import

    .PARAMETER Version
        The version of the local module to import

    .PARAMETER buildTarget
        Which version of the module to run tests against

        Allowed values:
            'Built', 'NotBuilt'

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\BaseUri\Get-RocketCyberBaseUri.Tests.ps1

        Runs a pester test and outputs simple results

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\BaseUri\Get-RocketCyberBaseUri.Tests.ps1 -Output Detailed

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


Describe "Testing [ $CommandName ] functions with [ $PesterTestName ]" -Tag @('BaseUri') {

Context "[ $CommandName ] testing functions" {

    It "[ $CommandName ] should have an alias" {
        Get-Alias -Name Add-RCBaseUri | Should -BeTrue
        Get-Alias -Name Set-RCBaseUri | Should -BeTrue
        Get-Alias -Name Set-RocketCyberBaseUri | Should -BeTrue
    }

    It "Without parameters should return the default URI" {
        Add-RocketCyberBaseUri
        Get-RocketCyberBaseUri | Should -Be 'https://api-us.rocketcyber.com/v3'
    }

    It "Should accept a value from the pipeline" {
        'https://celerium.org' | Add-RocketCyberBaseUri
        Get-RocketCyberBaseUri | Should -Be 'https://celerium.org'
    }

    It "With parameter -BaseUri <value> should return what was inputted" {
        Add-RocketCyberBaseUri -BaseUri 'https://celerium.org'
        Get-RocketCyberBaseUri | Should -Be 'https://celerium.org'
    }

    It "With parameter -DataCenter US should return the default URI" {
        Add-RocketCyberBaseUri -DataCenter 'US'
        Get-RocketCyberBaseUri | Should -Be 'https://api-us.rocketcyber.com/v3'
    }

    It "With parameter -DataCenter EU should return the default URI" {
        Add-RocketCyberBaseUri -DataCenter 'EU'
        Get-RocketCyberBaseUri | Should -Be 'https://api-eu.rocketcyber.com/v3'
    }

    It "With invalid parameter value -DataCenter Space should return an error" {
        Remove-RocketCyberBaseUri
        {Add-RocketCyberBaseUri -DataCenter Space} | Should -Throw
    }

    It "The default URI should NOT contain a trailing forward slash" {
        Add-RocketCyberBaseUri

        $URI = Get-RocketCyberBaseUri
        ($URI[$URI.Length-1] -eq "/") | Should -BeFalse
    }

    It "A custom URI should NOT contain a trailing forward slash" {
        Add-RocketCyberBaseUri -BaseUri 'https://celerium.org/'

        $URI = Get-RocketCyberBaseUri
        ($URI[$URI.Length-1] -eq "/") | Should -BeFalse
    }
}

}