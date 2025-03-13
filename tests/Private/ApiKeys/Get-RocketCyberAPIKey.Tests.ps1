<#
    .SYNOPSIS
        Pester tests for the Celerium.RocketCyber ApiKeys functions

    .DESCRIPTION
        Pester tests for the Celerium.RocketCyber ApiKeys functions

    .PARAMETER ModuleName
        The name of the local module to import

    .PARAMETER Version
        The version of the local module to import

    .PARAMETER buildTarget
        Which version of the module to run tests against

        Allowed values:
            'Built', 'NotBuilt'

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\ApiKeys\Get-RocketCyberApiKey.Tests.ps1

        Runs a pester test and outputs simple results

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\ApiKeys\Get-RocketCyberApiKey.Tests.ps1 -Output Detailed

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

        Remove-RocketCyberApiKey -WarningAction SilentlyContinue

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

Describe "Testing [ $CommandName ] function with [ $PesterTestName ]" -Tag @('ApiKeys') {

    Context "[ $CommandName ] testing function" {

        It "[ -ApiKey ] should accept input" {
            Add-RocketCyberApiKey -ApiKey '12345'
            Get-RocketCyberApiKey | Should -Not -BeNullOrEmpty
        }

        It "Pipeline  - [ -ApiKey ] should return a secure string" {
            "Celerium.RocketCyberKey" | Add-RocketCyberApiKey
            Get-RocketCyberApiKey | Should -BeOfType SecureString
        }

        It "Parameter - [ -ApiKey ] should return a secure string" {
            Add-RocketCyberApiKey -ApiKey '12345'
            Get-RocketCyberApiKey | Should -BeOfType SecureString
        }

        It "Using [ -AsPlainText ] should return [ -ApiKey ] as a string" {
            Add-RocketCyberApiKey -ApiKey '12345'
            Get-RocketCyberApiKey -AsPlainText | Should -BeOfType String
        }

        It "Using [ -AsPlainText ] should return the API key entered" {
            Add-RocketCyberApiKey -ApiKey '12345'
            Get-RocketCyberApiKey -AsPlainText | Should -Be '12345'
        }

        It "If [ -ApiKey ] is empty it should throw a warning" {
            Remove-RocketCyberApiKey
            Get-RocketCyberApiKey -WarningAction SilentlyContinue -WarningVariable apiKeyWarning
            [bool]$apiKeyWarning | Should -BeTrue
        }

    }

}