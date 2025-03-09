function Get-RocketCyberEvent {
<#
    .SYNOPSIS
        Gets app event information from the RocketCyber API

    .DESCRIPTION
        The Get-RocketCyberEvent cmdlet gets app event information for
        events associated to all or a defined account ID

        Use the Get-RockerCyberApp cmdlet to get app ids

    .PARAMETER AppId
        The app ID

    .PARAMETER Verdict
        The verdict of the event

        Multiple comma separated values can be inputted

        Allowed Values:
        'informational', 'suspicious', 'malicious'

    .PARAMETER AccountId
        The account id associated to the device

        If not provided, data will be pulled for all accounts
        accessible by the key

        Multiple comma separated values can be inputted

    .PARAMETER EventSummary
        Shows summary of events for each app

        AccountId cannot be an array when using this parameter

    .PARAMETER Details
        This parameter allows users to target specific attributes within the Details object

        This requires you to define the attribute path (period separated) and the expected value

        The value can include wildcards (*)

        Example: (AppId 7)
            attributes.direction:outbound

    .PARAMETER Dates
        The date range for event detections

        Both the start and end dates are optional, but at least one is
        required to use this parameter

        Start Time | End Time

        Example:
            2022-05-09  |2022-05-10
            2022-05-09  |
                        |2022-05-10

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
            verdict:asc
            dates:desc

    .PARAMETER AllResults
        Returns all items from an endpoint

    .EXAMPLE
        Get-RocketCyberEvent -AppId 7

        Gets the first 1000 AppId 7 events from all accounts accessible
        by the key

    .EXAMPLE
        Get-RocketCyberEvent -AccountId 12345 -AppId 7

        Gets the first 1000 AppId 7 events from account 12345

    .EXAMPLE
        Get-RocketCyberEvent -AppId 7 -sort dates:desc

        Gets the first 1000 AppId 7 events and the data set is sort
        by dates in descending order

    .EXAMPLE
        Get-RocketCyberEvent -AppId 7 -Verdict suspicious

        Gets the first 1000 AppId 7 events and the data set is sort
        by dates in descending order

    .NOTES
        As of 2023-03
            Other than the parameters shown here, app specific parameters vary from app to app,
            however I have not found any documentation around this

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Events/Get-RocketCyberEvent.html

#>

    [CmdletBinding(DefaultParameterSetName = 'IndexByEvent')]
    [alias("Get-RCEvent")]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'IndexByEvent')]
        [ValidateRange(1, [int]::MaxValue)]
        [Int]$AppId,

        [Parameter(Mandatory = $false, ParameterSetName = 'IndexByEvent')]
        [ValidateSet( 'informational', 'suspicious', 'malicious' )]
        [String[]]$Verdict,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'IndexByEvent')]
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'IndexByEventSummary')]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64[]]$AccountId,

        [Parameter(Mandatory = $true, ParameterSetName = 'IndexByEventSummary')]
        [Switch]$EventSummary,

        [Parameter(Mandatory = $false, ParameterSetName = 'IndexByEvent')]
        [ValidateNotNullOrEmpty()]
        [String]$Details,

        [Parameter(Mandatory = $false, ParameterSetName = 'IndexByEvent')]
        [ValidateNotNullOrEmpty()]
        [String]$Dates,

        [Parameter(Mandatory = $false, ParameterSetName = 'IndexByEvent')]
        [ValidateRange(1, [int]::MaxValue)]
        [Int]$Page,

        [Parameter(Mandatory = $false, ParameterSetName = 'IndexByEvent')]
        [ValidateRange(1, 1000)]
        [Int]$PageSize,

        [Parameter(Mandatory = $false, ParameterSetName = 'IndexByEvent')]
        [ValidateNotNullOrEmpty()]
        [String]$Sort,

        [Parameter(Mandatory = $false, ParameterSetName = 'IndexByEvent')]
        [Switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] ParameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'IndexByEvent'          { $ResourceUri = "/events"}
            'IndexByEventSummary'   { $ResourceUri = "/events/summary" }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($AccountId) { $UriParameters['accountId']   = $AccountId }

        if ($PSCmdlet.ParameterSetName -eq 'IndexByEvent') {
            if ($AppId)     { $UriParameters['appId']       = $AppId }
            if ($Verdict)   { $UriParameters['verdict']     = $Verdict }
            if ($Details)   { $UriParameters['details']     = $Details }
            if ($Dates)     { $UriParameters['dates']       = $Dates }
            if ($Page)      { $UriParameters['page']        = $Page }
            if ($PageSize)  { $UriParameters['pageSize']    = $PageSize }
            if ($Sort)      { $UriParameters['sort']        = $Sort }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-RocketCyberRequest -Method GET -ResourceUri $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end{}

}
