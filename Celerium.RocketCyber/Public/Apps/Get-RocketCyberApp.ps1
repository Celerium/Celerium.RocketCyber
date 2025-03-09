function Get-RocketCyberApp {
<#
    .SYNOPSIS
        Gets an accounts apps from the RocketCyber API

    .DESCRIPTION
        The Get-RocketCyberApp cmdlet gets an accounts apps
        from the RocketCyber API

        Can be used with the Get-RocketCyberEvent cmdlet

    .PARAMETER AccountId
        The account ID to pull data for

        If not provided, data will be pulled for all accounts
        accessible by the key

    .PARAMETER Status
        The type of apps to request

        Acceptable values are:
            'active', 'inactive'

        The default value is 'active'

    .EXAMPLE
        Get-RocketCyberApp

        Gets active apps from accounts accessible
        by the key

    .EXAMPLE
        Get-RocketCyberApp -AccountId 12345

        Gets active apps from account 12345

    .EXAMPLE
        Get-RocketCyberApp -AccountId 12345 -status inactive

        Gets inactive apps from account 12345

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Apps/Get-RocketCyberApp.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    [alias("Get-RCApp")]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64]$AccountId,

        [Parameter(Mandatory = $false)]
        [ValidateSet( 'active', 'inactive' )]
        [String]$Status
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] ParameterSet"

        $ResourceUri = '/apps'

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($AccountId) { $UriParameters['accountId']   = $AccountId }
        if ($Status)    { $UriParameters['status']      = $Status }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-RocketCyberRequest -Method GET -ResourceUri $ResourceUri -UriFilter $UriParameters

    }

    end{}

}