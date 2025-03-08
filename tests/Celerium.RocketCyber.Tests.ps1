<#
.NOTES
    Copyright 1990-2024 Celerium

    NAME: Celerium.RocketCyber.Tests.ps1
    Type: PowerShell

        AUTHOR:  David Schulte
        DATE:    2023-04-1
        EMAIL:   celerium@Celerium.org
        Updated: 2023-09-16

    TODO:
    Huge thank you to LazyWinAdmin, Vexx32, & JeffBrown for their blog posts!

.SYNOPSIS
    Pester tests for the Celerium.RocketCyber module manifest file.

.DESCRIPTION
    Pester tests for the Celerium.RocketCyber module manifest file.

.PARAMETER moduleName
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

.LINK
    https://celerium.org

.LINK
    https://vexx32.github.io/2020/07/08/Verify-Module-Help-Pester/
    https://lazywinadmin.com/2016/05/using-pester-to-test-your-comment-based.html
    https://jeffbrown.tech/getting-started-with-pester-testing-in-powershell/
    https://github.com/Celerium/Celerium.RocketCyber

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
    [Parameter(Mandatory = $false)]
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

#Available in Describe and Context but NOT It
#Can be used in [ It ] with [ -TestCases @{ VariableName = $VariableName } ]
    BeforeDiscovery{

        $PesterTestName = (Get-Item -Path $PSCommandPath).Name
        $CommandName = $PesterTestName -replace '.Tests.ps1',''

    }

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
        $modulePsm1 = Join-Path -Path $ModulePath -ChildPath "$ModuleName.psm1"

        Import-Module -Name $ModulePsd1 -ErrorAction Stop -ErrorVariable moduleError *> $null

        $Module = Get-Module -Name $ModuleName | Select-Object * -ExcludeProperty Definition
        $moduleFiles = Get-ChildItem -Path $ModulePath -File -Recurse

        if ($ModuleError) {
            $ModuleError
            exit 1
        }

    }

    AfterAll{

        if (Get-Module -Name $ModuleName) {
            Remove-Module -Name $ModuleName -Force
        }

    }

#EndRegion  [ Prerequisites ]

Describe "Testing the [ $BuildTarget ] version of [ $ModuleName ] with [ $PesterTestName ]" {

    Context "[ $ModuleName.psd1 ] general manifest data" {

        It "Manifest [ RootModule ] has valid data" {
            $Module.RootModule | Should -Be 'Celerium.RocketCyber.psm1'
        }

        It "Manifest [ ModuleVersion ] has valid data" {
            $Module.Version | Should -BeGreaterOrEqual $Version
        }

        It "Manifest [ GUID ] has valid data" {
            $Module.GUID | Should -Be 'cba0c431-1670-43d7-a2db-4ab683da7dcb'
        }

        It "Manifest [ Author ] has valid data" {
            $Module.Author | Should -Be 'David Schulte'
        }

        It "Manifest [ CompanyName ] has valid data" {
            $Module.CompanyName | Should -Be 'Celerium'
        }

        It "Manifest [ Copyright ] has valid data" {
            $Module.Copyright | Should -Be 'https://github.com/Celerium/Celerium.RocketCyber/blob/main/LICENSE'
        }

        It "Manifest [ Description ] is not empty" {
            $Module.Description | Should -Not -BeNullOrEmpty
        }

        It "Manifest [ PowerShellVersion ] has valid data" {
            $Module.PowerShellVersion | Should -BeGreaterOrEqual '5.0'
        }

        It "Manifest [ NestedModules ] has valid data" {
            switch ($BuildTarget) {
                'Built'     { ($Module.NestedModules.Name).Count | Should -Be 0 }
                'NotBuilt'  { ($Module.NestedModules.Name).Count | Should -Be 22 }
            }
        }

        It "Manifest [ FunctionsToExport ] has valid data" {
            ($Module.ExportedCommands).Count | Should -Be 45
        }

        It "Manifest [ CmdletsToExport ] is empty" {
            ($Module.ExportedCmdlets).Count |  Should -Be 0
        }

        It "Manifest [ VariablesToExport ] is empty" {
            ($Module.ExportedVariables).Count |  Should -Be 0
        }

        It "Manifest [ AliasesToExport ] has alias" {
            switch ($BuildTarget) {
                'Built'     { ($Module.ExportedAliases).Count |  Should -Be 24 }
                'NotBuilt'  { $Module.ExportedAliases |  Should -Not -BeNullOrEmpty }
            }
        }

        It "Manifest [ Tags ] has valid data" {
            $Module.PrivateData.PSData.Tags | Should -Contain 'RocketCyber'
            $Module.PrivateData.PSData.Tags | Should -Contain 'Celerium'
            ($Module.PrivateData.PSData.Tags).Count | Should -BeGreaterOrEqual 7
        }

        It "Manifest [ LicenseUri ] has valid data" {
            $Module.LicenseUri | Should -Be 'https://github.com/Celerium/Celerium.RocketCyber/blob/main/LICENSE'
        }

        It "Manifest [ ProjectUri ] has valid data" {
            $Module.ProjectUri  | Should -Be 'https://github.com/Celerium/Celerium.RocketCyber'
        }

        It "Manifest [ IconUri ] has valid data" {
            $Module.IconUri  | Should -Be 'https://raw.githubusercontent.com/Celerium/Celerium.RocketCyber/main/.github/images/Celerium_PoSHGallery_Celerium.RocketCyber.png'
        }

        It "Manifest [ ReleaseNotes ] has valid data" {
            $Module.ReleaseNotes  | Should -Be 'https://github.com/Celerium/Celerium.RocketCyber/blob/main/README.md'
        }

        It "Manifest [ HelpInfoUri ] is not empty" {
            $Module.HelpInfoUri | Should -BeNullOrEmpty
        }

    }

    Context "[ $ModuleName.psd1 ] module import test" {

        It "Module contains only PowerShell files" {
            ($moduleFiles | Group-Object Extension).Name.Count | Should -BeLessOrEqual 3
        }

        It "Module files exist" {
            $ModulePsd1 | Should -Exist
            $modulePsm1 | Should -Exist
        }

        It "Should pass Test-ModuleManifest" {
            $ModulePsd1 | Test-ModuleManifest -ErrorAction SilentlyContinue -ErrorVariable error_ModuleManifest
            [bool]$error_ModuleManifest | Should -Be $false
        }

        It "Should import successfully" {
            Import-Module $ModulePsd1 -ErrorAction SilentlyContinue -ErrorVariable error_ModuleImport
            [bool]$error_ModuleImport | Should -Be $false
        }

    }

}