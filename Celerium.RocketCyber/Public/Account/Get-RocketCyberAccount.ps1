function Get-RocketCyberAccount {
<#
    .SYNOPSIS
        Gets account information for a given ID

    .DESCRIPTION
        The Get-RocketCyberAccount cmdlet gets account information all
        accounts or for a given ID from the RocketCyber API

    .PARAMETER AccountId
        The account ID to pull data for

        If not provided, data will be pulled for all accounts
        accessible by the key

    .PARAMETER Details
        Should additional Details for each sub-accounts be displayed
        in the return data

    .EXAMPLE
        Get-RocketCyberAccount

        Account data will be retrieved from all accounts accessible
        by the key

    .EXAMPLE
        Get-RocketCyberAccount -AccountId 12345

        Account data will be retrieved for the account with the AccountId 12345

    .EXAMPLE
        12345 | Get-RocketCyberAccount

        Account data will be retrieved for the account with the AccountId 12345

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Account/Get-RocketCyberAccount.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    [alias("Get-RCAccount")]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64]$AccountId,

        [Parameter(Mandatory = $false)]
        [Switch]$Details

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] ParameterSet"

        $ResourceUri = '/account'

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($AccountId) { $UriParameters['accountId']   = $AccountId }
        if ($Details)   { $UriParameters['details']     = $Details }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-RocketCyberRequest -Method GET -ResourceUri $ResourceUri -UriFilter $UriParameters

    }

    end{}

}
