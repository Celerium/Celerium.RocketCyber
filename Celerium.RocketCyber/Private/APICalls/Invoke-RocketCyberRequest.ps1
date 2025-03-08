function Invoke-RocketCyberRequest {
<#
    .SYNOPSIS
        Makes an API request

    .DESCRIPTION
        The Invoke-RocketCyberRequest cmdlet invokes an API request to RocketCyber API

        This is an internal function that is used by all public functions

        As of 2023-08 the RocketCyber v1 API only supports GET requests

    .PARAMETER Method
        Defines the type of API method to use

        Allowed values:
        'GET'

    .PARAMETER ResourceUri
        Defines the resource uri (url) to use when creating the API call

    .PARAMETER UriFilter
        Used with the internal function [ ConvertTo-RocketCyberQueryString ] to combine
        a functions parameters with the ResourceUri parameter

        This allows for the full uri query to occur

        The full resource path is made with the following data
        $RocketCyberModuleBaseURI + $ResourceUri + ConvertTo-RocketCyberQueryString

    .PARAMETER Data
        Place holder parameter to use when other methods are supported
        by the RocketCyber v1 API

    .PARAMETER AllResults
        Returns all items from an endpoint

        When using this parameter there is no need to use either the page or perPage
        parameters

    .EXAMPLE
        Invoke-RocketCyberRequest -method GET -ResourceUri '/account' -UriFilter $UriFilter

        Invoke a rest method against the defined resource using any of the provided parameters

        Example:
            Name                           Value
            ----                           -----
            Method                         GET
            Uri                            https://api-us.rocketcyber.com/v3/account?AccountId=12345&details=True
            Headers                        {Authorization = Bearer 123456789}
            Body


    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Invoke-RocketCyberRequest.html

#>

    [CmdletBinding()]
    [alias("Invoke-RCRequest")]
    param (
        [Parameter(Mandatory = $false) ]
        [ValidateSet('GET')]
        [String]$Method = 'GET',

        [Parameter(Mandatory = $true)]
        [String]$ResourceUri,

        [Parameter(Mandatory = $false) ]
        [Hashtable]$UriFilter = $null,

        #[Parameter(Mandatory = $false) ]
        #[Hashtable]$Data = $null,

        [Parameter(Mandatory = $false) ]
        [Switch]$AllResults

    )

    begin {

        # Load Web assembly when needed as PowerShell Core has the assembly preloaded
        if ( !("System.Web.HttpUtility" -as [Type]) ) {
            Add-Type -Assembly System.Web
        }

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        $QueryString = ConvertTo-RocketCyberQueryString -UriFilter $UriFilter -ResourceUri $ResourceUri

        Set-Variable -Name $QueryParameterName -Value $QueryString -Scope Global -Force

        try {
            $ApiToken = Get-RocketCyberAPIKey -AsPlainText

            $Parameters = [ordered] @{
                "Method"    = $Method
                "Uri"       = $QueryString.Uri
                "Headers"   = @{ 'Authorization' = 'Bearer {0}' -f $ApiToken; 'Content-Type' = 'application/json' }
            }
            Set-Variable -Name $ParameterName -Value $Parameters -Scope Global -Force

            if ($AllResults) {

                Write-Verbose "Gathering all items from [  $( $RocketCyberModuleBaseURI + $ResourceUri ) ] "

                $PageNumber = 1
                $AllResponseData = [System.Collections.Generic.List[object]]::new()

                do {

                    $Parameters['Uri'] = $QueryString.Uri -replace '_page=\d+',"_page=$PageNumber"

                    $CurrentPage = Invoke-RestMethod @Parameters -ErrorAction Stop

                    Write-Verbose "[ $PageNumber ] of [ $($CurrentPage.totalPages) ] pages"

                        foreach ($item in $CurrentPage.data) {
                            $AllResponseData.add($item)
                        }

                    $PageNumber++

                } while ( $CurrentPage.totalPages -ne $PageNumber - 1 -and $CurrentPage.totalPages -ne 0 )

            }
            else{
                $ApiResponse = Invoke-RestMethod @parameters -ErrorAction Stop
            }

        }
        catch {

            $exceptionError = $_.Exception.Message
            Write-Warning 'The [ Invoke_RocketCyberRequest_Parameters, Invoke_RocketCyberRequest_ParametersQuery, & CmdletName_Parameters ] variables can provide extra details'

            switch -Wildcard ($exceptionError) {
                '*404*' { Write-Error "Invoke-RocketCyberRequest : [ $ResourceUri ] not found!" }
                '*429*' { Write-Error 'Invoke-RocketCyberRequest : API rate limited' }
                '*504*' { Write-Error "Invoke-RocketCyberRequest : Gateway Timeout" }
                default { Write-Error $_ }
            }

        }
        finally {

            $Auth = $RocketCyber_invokeParameters['headers']['Authorization']
            $RocketCyber_invokeParameters['headers']['Authorization'] = $Auth.Substring( 0, [Math]::Min($Auth.Length, 10) ) + '*******'

        }


        if($AllResults) {

            #Making output consistent
            if( [string]::IsNullOrEmpty($AllResponseData.data) -and ($AllResponseData | Measure-Object).Count -eq 0 ) {
                $ApiResponse = $null
            }
            else{
                $count = ($AllResponseData | Measure-Object).Count

                $ApiResponse = [PSCustomObject]@{
                    totalCount  = $count
                    currentPage = $null
                    totalPages  = $null
                    dataCount   = $count
                    data        = $AllResponseData
                }
            }

            return $ApiResponse

        }
        else{ return $ApiResponse }

    }

    end {}

}