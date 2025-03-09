function Get-RocketCyberAgent {
<#
    .SYNOPSIS
        Gets RocketCyber agents from an account

    .DESCRIPTION
        The Get-RocketCyberAgent cmdlet gets all the device information
        for all devices associated to the account ID provided

    .PARAMETER AccountId
        The account id associated to the device

        If not provided, data will be pulled for all accounts
        accessible by the key

        Multiple comma separated values can be inputted

    .PARAMETER ID
        The agent id

        Multiple comma separated values can be inputted

    .PARAMETER Hostname
        The device hostname

        Multiple comma separated values can be inputted

    .PARAMETER IP
        The IP address tied to the device

        Multiple comma separated values can be inputted

    .PARAMETER Created
        The date range for when agents were created

        Both the start and end dates are optional, but at least one is
        required to use this parameter

        Cannot be used with the StartDate & EndDate parameters

        Start UTC Time | End UTC Time

        Example:
            2022-05-09T00:33:38.245Z|2022-05-10T23:59:38.245Z
            2022-05-09T00:33:38.245Z|
                                    |2022-05-10T23:59:38.245Z

    .PARAMETER StartDate
        The friendly start date for when agents were created

        Both the start and end dates are optional, but at least one is
        required to use this parameter

        Cannot be used with the created parameter

        Date needs to be inputted as yyyy-mm-dd hh:mm:ss

    .PARAMETER EndDate
        The friendly end date for when agents were created

        Both the start and end dates are optional, but at least one is
        required to use this parameter

        Cannot be used with the created parameter

        Date needs to be inputted as yyyy-mm-dd hh:mm:ss

    .PARAMETER OS
        The OS used by the device

        As of 2023-03 using * do not appear to work correctly

        Example:
            Windows*
            Windows

    .PARAMETER Version
        The agent version

        As of 2023-03 this filter appears not to work correctly

        Example:
            Server 2019

    .PARAMETER Connectivity
        The connectivity status of the agent

        Multiple comma separated values can be inputted

        Allowed values:
            'online', 'offline', 'isolated'

    .PARAMETER Page
        The target page of data

        This is used with pageSize parameter to determine how many
        and which items to return

    .PARAMETER PageSize
        The number of items to return from the data set

    .PARAMETER Sort
        The sort order for the items queried

        Not all values can be sorted

        Example:
            hostname:asc
            AccountId:desc

    .PARAMETER AllResults
        Returns all items from an endpoint

    .EXAMPLE
        Get-RocketCyberAgent

        Gets the first 1000 agents from all accounts accessible
        by the key

    .EXAMPLE
        Get-RocketCyberAgent -ID 12345

        Gets the first 1000 agents from account 12345

    .EXAMPLE
        Get-RocketCyberAgent -ID 12345 -sort hostname:asc

        Gets the first 1000 agents from account 12345

        Data is sorted by hostname and returned in ascending order

    .EXAMPLE
        Get-RocketCyberAgent -ID 12345 -Connectivity offline,isolated

        Gets the first 1000 offline agents from account 12345 that are
        either offline or isolated

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Agents/Get-RocketCyberAgent.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    [alias("Get-RCAgent")]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64[]]$AccountId,

        [Parameter(Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$ID,

        [Parameter(Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$Hostname,

        [Parameter(Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$IP,

        [Parameter(Mandatory = $false, ParameterSetName = 'Index')]
        [ValidateNotNullOrEmpty()]
        [String]$Created,

        [Parameter(Mandatory = $false, ParameterSetName = 'IndexByCustomTime')]
        [ValidateNotNullOrEmpty()]
        [DateTime]$StartDate,

        [Parameter(Mandatory = $false, ParameterSetName = 'IndexByCustomTime')]
        [ValidateNotNullOrEmpty()]
        [DateTime]$EndDate,

        [Parameter(Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$OS,

        [Parameter(Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$Version,

        [Parameter(Mandatory = $false) ]
        [ValidateSet( 'online', 'offline', 'isolated' )]
        [String[]]$Connectivity,

        [Parameter(Mandatory = $false) ]
        [ValidateRange(1, [int]::MaxValue)]
        [Int]$Page,

        [Parameter(Mandatory = $false) ]
        [ValidateRange(1, 1000)]
        [Int]$PageSize,

        [Parameter(Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$Sort,

        [Parameter(Mandatory = $false) ]
        [Switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] ParameterSet"

        $ResourceUri = '/agents'

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($AccountId)     { $UriParameters['accountId']       = $AccountId }
        if ($ID)            { $UriParameters['id']              = $ID }
        if ($Hostname)      { $UriParameters['hostname']        = $Hostname }
        if ($IP)            { $UriParameters['ip']              = $IP }
        if ($Hostname)      { $UriParameters['hostname']        = $Hostname }
        if ($OS)            { $UriParameters['os']              = $OS }
        if ($Version)       { $UriParameters['version']         = $Version }
        if ($Connectivity)  { $UriParameters['connectivity']    = $Connectivity }
        if ($Page)          { $UriParameters['page']            = $Page }
        if ($PageSize)      { $UriParameters['pageSize']        = $PageSize }
        if ($Sort)          { $UriParameters['sort']            = $Sort }

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($Created)   { $UriParameters['created']     = $Created }
        }

        if ($PSCmdlet.ParameterSetName -eq 'IndexByCustomTime') {

            if ($StartDate) {
                $StartTime    = $StartDate.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
                Write-Verbose "Converting [ $StartDate ] to [ $StartTime ]"
            }
            if ($EndDate)   {
                $EndTime      = $EndDate.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
                Write-Verbose "Converting [ $EndDate ] to [ $EndTime ]"
            }

            $CreatedQuery = $StartTime + '|' + $EndTime
            $UriParameters['created']     = $CreatedQuery

        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-RocketCyberRequest -Method GET -ResourceUri $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end{}

}
