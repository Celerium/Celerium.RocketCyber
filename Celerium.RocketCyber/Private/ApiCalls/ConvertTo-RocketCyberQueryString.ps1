function ConvertTo-RocketCyberQueryString {
<#
    .SYNOPSIS
        Converts uri filter parameters

    .DESCRIPTION
        The Invoke-RocketCyberRequest cmdlet converts & formats uri filter parameters
        from a function which are later used to make the full resource uri for
        an API call

        This is an internal helper function the ties in directly with the
        Invoke-RocketCyberRequest & any public functions that define parameters

    .PARAMETER UriFilter
        Hashtable of values to combine a functions parameters with
        the ResourceUri parameter

        This allows for the full uri query to occur

    .PARAMETER ResourceUri
        Defines the short resource uri (url) to use when creating the API call

    .EXAMPLE
        ConvertTo-RocketCyberQueryString -UriFilter $UriFilter -ResourceUri '/account'

        Example: (From public function)
            $UriFilter = @{}

            ForEach ( $Key in $PSBoundParameters.GetEnumerator() ) {
                if( $excludedParameters -contains $Key.Key ) {$null}
                else{ $UriFilter += @{ $Key.Key = $Key.Value } }
            }

            1x key = https://api-us.rocketcyber.com/v3/account?AccountId=12345
            2x key = https://api-us.rocketcyber.com/v3/account?AccountId=12345&details=True

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/ConvertTo-RocketCyberQueryString.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Convert')]
    [alias("ConvertTo-RCQueryString")]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [hashtable]$UriFilter,

        [Parameter(Mandatory = $true)]
        [String]$ResourceUri
    )

    begin {}

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] ParameterSet"

        $QueryParameters = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)

        if ($UriFilter) {

            foreach ( $Key in $UriFilter.GetEnumerator() ) {

                if ( $Key.Value.GetType().IsArray ) {
                    Write-Verbose "[ $($Key.Key) ] is an array parameter"
                    foreach ($Value in $Key.Value) {
                        $QueryParameters.Add($Key.Key, $Value)
                    }
                }
                else{
                    $QueryParameters.Add($Key.Key, $Key.Value)
                }

            }

        }

        # Build the request and load it with the query string
        $uri_Request        = [System.UriBuilder]($RocketCyberModuleBaseUri + $ResourceUri)
        $uri_Request.Query  = $QueryParameters.ToString()

        return $uri_Request

    }

    end {}

}