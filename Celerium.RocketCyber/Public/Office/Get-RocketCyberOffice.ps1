function Get-RocketCyberOffice {
<#
    .SYNOPSIS
        Gets office information from the RocketCyber API

    .DESCRIPTION
        The Get-RocketCyberOffice cmdlet gets office information
        from all or a defined AccountId

    .PARAMETER AccountId
        The account ID to pull data for

        If not provided, data will be pulled for all accounts
        accessible by the key

    .EXAMPLE
        Get-RocketCyberOffice

        Office data will be retrieved from all accounts accessible
        by the key

    .EXAMPLE
        Get-RocketCyberOffice -AccountId 12345

        Office data will be retrieved from the AccountId 12345

    .EXAMPLE
        12345 | Get-RocketCyberOffice

        Office data will be retrieved from the AccountId 12345

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Office/Get-RocketCyberOffice.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    [alias("Get-RCOffice")]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64[]]$AccountId

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] ParameterSet"

        $ResourceUri = '/office'

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($AccountId) { $UriParameters['accountId']   = $AccountId }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-RocketCyberRequest -Method GET -ResourceUri $ResourceUri -UriFilter $UriParameters

    }

    end{}

}
