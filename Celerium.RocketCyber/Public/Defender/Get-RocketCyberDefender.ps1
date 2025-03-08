function Get-RocketCyberDefender {
<#
    .SYNOPSIS
        Gets defender information from the RocketCyber API

    .DESCRIPTION
        The Get-RocketCyberDefender cmdlet gets an accounts defender information
        from the RocketCyber API

        This includes various health & risk values

    .PARAMETER AccountId
        The account ID to pull data for

        If not provided, data will be pulled for all accounts
        accessible by the key

    .EXAMPLE
        Get-RocketCyberDefender

        Gets defender information all accounts accessible
        by the key

    .EXAMPLE
        Get-RocketCyberDefender -AccountId 12345

        Gets defender information from account 12345

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Defender/Get-RocketCyberDefender.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    [alias("Get-RCDefender")]
    Param (
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64]$AccountId
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] ParameterSet"

        $ResourceUri = '/defender'

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