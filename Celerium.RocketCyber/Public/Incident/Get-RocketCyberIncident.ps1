function Get-RocketCyberIncident {
<#
    .SYNOPSIS
        Gets incident information from the RocketCyber API

    .DESCRIPTION
        The Get-RocketCyberIncident cmdlet gets incident information
        associated to all or a defined account ID

    .PARAMETER ID
        The RocketCyber incident ID

        Multiple comma separated values can be inputted

    .PARAMETER Title
        The title of the incident

        Example:
            Office*

        Multiple comma separated values can be inputted

    .PARAMETER AccountId
        The account id associated to the device

        If not provided, data will be pulled for all accounts
        accessible by the key

        Multiple comma separated values can be inputted

    .PARAMETER Description
        The description of the incident

        NOTE: Wildcards are required to search for specific text

        Example:
            administrative

    .PARAMETER Remediation
        The remediation for the incident

        NOTE: Wildcards are required to search for specific text

        Example:
            permission*

        As of 2023-03 this parameters does not appear to work

    .PARAMETER ResolvedAt
        This returns incidents resolved between the start and end date

        Both the start and end dates are optional, but at least one is
        required to use this parameter

        Start Time  |  End Time

        Example:
            2022-05-09  |2022-05-10
            2022-05-09  |
                        |2022-05-10

    .PARAMETER CreatedAt
        This returns incidents created between the start and end date

        Both the start and end dates are optional, but at least one is
        required to use this parameter

        Start Time  |  End Time

        Example:
            2022-05-09  |2022-05-10
            2022-05-09  |
                        |2022-05-10

    .PARAMETER Status
        The type of incidents to request

        Allowed Values:
            'open', 'resolved'

        As of 2023-03 the documentation defines the
        allowed values listed below but not all work

        'all', 'open', 'closed'

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
            AccountId:asc
            title:desc

    .PARAMETER AllResults
        Returns all items from an endpoint

    .EXAMPLE
        Get-RocketCyberIncident

        Gets the first 1000 incidents from all accounts accessible
        by the key

    .EXAMPLE
        Get-RocketCyberIncident -AccountId 12345 -Id 9876

        Gets the defined incident Id from the defined AccountId

    .EXAMPLE
        Get-RocketCyberIncident -Title nmap -ResolvedAt '2023-01-01|'

        Gets the first 1000 incidents from all accounts accessible
        by the key that were resolved after the defined
        startDate with the defined word in the title

    .EXAMPLE
        Get-RocketCyberIncident -Description audit -CreatedAt '|2023-03-01'

        Gets the first 1000 incidents from all accounts accessible
        by the key that were created before the defined
        endDate with the defined word in the description

    .EXAMPLE
        Get-RocketCyberIncident -status resolved -sort title:asc

        Gets the first 1000 resolved incidents from all accounts accessible
        by the key and the data is return by title in
        ascending order

    .NOTES
        As of 2023-03:
            Any parameters that say wildcards are required is not valid

            Using wildcards in the query string do not work as the endpoint
            already search's via wildcard. If you use a wildcard '*' it
            will not return any results

        The remediation parameter does not appear to work

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Incident/Get-RocketCyberIncident.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    [alias("Get-RCIncident")]
    Param (
        [Parameter(Mandatory = $false) ]
        [ValidateRange(1, [int]::MaxValue)]
        [Int[]]$ID,

        [Parameter(Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$Title,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64[]]$AccountId,

        [Parameter(Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$Description,

        [Parameter(Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$Remediation,

        [Parameter(Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$ResolvedAt,

        [Parameter(Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$CreatedAt,

        [Parameter(Mandatory = $false) ]
        [ValidateSet( 'open', 'resolved' )]
        [String[]]$Status,

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

        $ResourceUri = '/incidents'

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($ID)            { $UriParameters['id']          = $ID }
        if ($Title)         { $UriParameters['title']       = $Title }
        if ($AccountId)     { $UriParameters['accountId']   = $AccountId }
        if ($Description)   { $UriParameters['description'] = $Description }
        if ($Remediation)   { $UriParameters['remediation'] = $Remediation }
        if ($ResolvedAt)    { $UriParameters['resolvedAt']  = $ResolvedAt }
        if ($CreatedAt)     { $UriParameters['createdAt']   = $CreatedAt }
        if ($Status)        { $UriParameters['status']      = $Status }
        if ($Page)          { $UriParameters['page']        = $Page }
        if ($PageSize)      { $UriParameters['pageSize']    = $PageSize }
        if ($Sort)          { $UriParameters['sort']        = $Sort }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-RocketCyberRequest -Method GET -ResourceUri $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end{}

}
