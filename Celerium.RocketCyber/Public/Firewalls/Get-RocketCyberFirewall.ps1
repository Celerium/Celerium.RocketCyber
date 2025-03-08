function Get-RocketCyberFirewall {
<#
    .SYNOPSIS
        Gets RocketCyber firewalls from an account

    .DESCRIPTION
        The Get-RocketCyberFirewall cmdlet gets firewalls from
        an account

    .PARAMETER AccountId
        The account id associated to the device

        If not provided, data will be pulled for all accounts
        accessible by the key

        Multiple comma separated values can be inputted

    .PARAMETER DeviceId
        The device ID tied to the device

    .PARAMETER IPAddress
        The IP address tied to the device

        As of 2023-03 this endpoint does not return
        IP address information

        Example:
            172.25.5.254

    .PARAMETER MACAddress
        The MAC address tied to the device

        Example:
            ae:b1:69:29:55:24

        Multiple comma separated values can be inputted

    .PARAMETER Type
        The type of device

        Example:
            SonicWall,Fortinet

        Multiple comma separated values can be inputted

    .PARAMETER Counters
        Flag to include additional firewall counter data

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
            AccountId:desc

    .PARAMETER AllResults
        Returns all items from an endpoint

    .EXAMPLE
        Get-RocketCyberFirewall

        Gets the first 1000 agents from all accounts accessible
        by the key

    .EXAMPLE
        Get-RocketCyberFirewall -AccountId 12345

        The first 1000 firewalls are pulled from AccountId 12345

    .EXAMPLE
        Get-RocketCyberFirewall -MACAddress '11:22:33:aa:bb:cc'

        Get the firewall with the defined MACAddress

    .EXAMPLE
        Get-RocketCyberFirewall -Type SonicWall,Fortinet

        Get firewalls with the defined type

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Firewalls/Get-RocketCyberFirewall.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    [alias("Get-RCFirewall")]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64[]]$AccountId,

        [Parameter(Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$DeviceId,

        [Parameter(Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$IPAddress,

        [Parameter(Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$MACAddress,

        [Parameter(Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$Type,

        [Parameter(Mandatory = $false) ]
        [Switch]$Counters,

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

        $ResourceUri = '/firewalls'

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($AccountId)     { $UriParameters['accountId']   = $AccountId }
        if ($DeviceId)      { $UriParameters['deviceId']    = $DeviceId }
        if ($IPAddress)     { $UriParameters['ipAddress']   = $IPAddress }
        if ($MACAddress)    { $UriParameters['macAddress']  = $MACAddress }
        if ($Type)          { $UriParameters['type']        = $Type }
        if ($Counters)      { $UriParameters['counters']    = $Counters }
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
