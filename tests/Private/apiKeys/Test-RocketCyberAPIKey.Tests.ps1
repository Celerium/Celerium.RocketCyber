<#
    .SYNOPSIS
        Pester tests for the Celerium.RocketCyber APIKeys functions

    .DESCRIPTION
        Pester tests for the Celerium.RocketCyber APIKeys functions

    .PARAMETER moduleName
        The name of the local module to import

    .PARAMETER Version
        The version of the local module to import

    .PARAMETER buildTarget
        Which version of the module to run tests against

        Allowed values:
            'Built', 'NotBuilt'

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\APIKeys\Remove-RocketCyberAPIKey.Tests.ps1

        Runs a pester test and outputs simple results

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\APIKeys\Remove-RocketCyberAPIKey.Tests.ps1 -Output Detailed

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

        Set-Variable -Name PSCommandPath123 -Value $PSCommandPath -Scope Global -Force

        if ($IsWindows -or $PSEdition -eq 'Desktop') {
            $RootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\tests', [System.StringComparison]::OrdinalIgnoreCase)) )"
        }
        else{
            $RootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('/tests', [System.StringComparison]::OrdinalIgnoreCase)) )"
        }

        Set-Variable -Name rootPath123 -Value $RootPath -Scope Global -Force

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

        Remove-RocketCyberBaseUri -WarningAction SilentlyContinue
        Remove-RocketCyberAPIKey -WarningAction SilentlyContinue

        Foreach ($script in $import_Scripts) {
            if (Get-Module -Name $script.BaseName) {
                Remove-Module -Name $script.BaseName -Force
            }
        }

    }


#Available in Describe and Context but NOT It
#Can be used in [ It ] with [ -TestCases @{ VariableName = $VariableName } ]
    BeforeDiscovery{

        $PesterTestName = (Get-Item -Path $PSCommandPath).Name
        $CommandName = $PesterTestName -replace '.Tests.ps1',''

    }

#EndRegion  [ Prerequisites ]

Describe "Testing [ $CommandName ] function with [ $PesterTestName ]" -Tag @('APIKeys') {

    Context "[ $CommandName ] testing function" {

        It "[ Test-RocketCyberAPIKey ] with a bad API key should fail to authenticate" {
            Add-RocketCyberBaseUri
            Add-RocketCyberAPIKey -ApiKey '12345'

            $Value = Test-RocketCyberAPIKey 3>$null
            $Value.Message | Should -BeLike '*Unauthorized*'
        }

    }

}