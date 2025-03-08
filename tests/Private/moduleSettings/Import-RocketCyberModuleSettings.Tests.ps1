<#
    .SYNOPSIS
        Pester tests for the Celerium.RocketCyber ModuleSettings functions

    .DESCRIPTION
        Pester tests for the Celerium.RocketCyber ModuleSettings functions

    .PARAMETER ModuleName
        The name of the local module to import

    .PARAMETER Version
        The version of the local module to import

    .PARAMETER buildTarget
        Which version of the module to run tests against

        Allowed values:
            'Built', 'NotBuilt'

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\ModuleSettings\Get-RocketCyberModuleSettings.Tests.ps1

        Runs a pester test and outputs simple results

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\ModuleSettings\Get-RocketCyberModuleSettings.Tests.ps1 -Output Detailed

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
        $invalidPath = $(Join-Path -Path $home -ChildPath "invalidApiPath")
        if ($IsWindows -or $PSEdition -eq 'Desktop') {
            $ExportPath = $(Join-Path -Path $home -ChildPath "Celerium.RocketCyber_Test")
        }
        else{
            $ExportPath = $(Join-Path -Path $home -ChildPath ".Celerium.RocketCyber_Test")
        }

        Import-Module -Name $ModulePsd1 -ErrorAction Stop -ErrorVariable moduleError *> $null

        if ($ModuleError) {
            $ModuleError
            exit 1
        }

    }

    AfterAll{

        Remove-RocketCyberModuleSettings -RocketCyberConfigPath $ExportPath

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

Describe "Testing [ $CommandName ] function with [ $PesterTestName ]" -Tag @('ModuleSettings') {

    Context "[ $CommandName ] testing function" {

        It "No configuration should populate baseline variables" {
            Import-RocketCyberModuleSettings -RocketCyberConfigPath $invalidPath -RocketCyberConfigFile 'invalid.psd1'

            (Get-Variable -Name RocketCyberModuleBaseURI).Value | Should -Be $(Get-RocketCyberBaseUri)
        }

        It "Saved configuration session should contain required variables" {
            Add-RocketCyberBaseUri
            Add-RocketCyberAPIKey -ApiKey '12345'

            Export-RocketCyberModuleSettings -RocketCyberConfigPath $ExportPath -WarningAction SilentlyContinue
            Import-RocketCyberModuleSettings -RocketCyberConfigPath $ExportPath

            (Get-Variable -Name RocketCyberModuleBaseURI).Value         | Should -Not -BeNullOrEmpty
            (Get-Variable -Name RocketCyberModuleApiKey).Value    | Should -Not -BeNullOrEmpty
        }

        It "Saved configuration session should NOT contain temp variables" {
            Add-RocketCyberBaseUri
            Add-RocketCyberAPIKey -ApiKey '12345'

            Export-RocketCyberModuleSettings -RocketCyberConfigPath $ExportPath -WarningAction SilentlyContinue
            Import-RocketCyberModuleSettings -RocketCyberConfigPath $ExportPath

            (Get-Variable -Name TempConfig -ErrorAction SilentlyContinue).Value | Should -BeNullOrEmpty
        }

    }

}