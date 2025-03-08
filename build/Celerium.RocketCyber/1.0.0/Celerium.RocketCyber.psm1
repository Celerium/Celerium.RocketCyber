#Region '.\Private\ApiCalls\ConvertTo-RocketCyberQueryString.ps1' -1

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
#EndRegion '.\Private\ApiCalls\ConvertTo-RocketCyberQueryString.ps1' 90
#Region '.\Private\ApiCalls\Invoke-RocketCyberRequest.ps1' -1

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
        $RocketCyberModuleBaseUri + $ResourceUri + ConvertTo-RocketCyberQueryString

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
            $ApiToken = Get-RocketCyberApiKey -AsPlainText

            $Parameters = [ordered] @{
                "Method"    = $Method
                "Uri"       = $QueryString.Uri
                "Headers"   = @{ 'Authorization' = 'Bearer {0}' -f $ApiToken; 'Content-Type' = 'application/json' }
            }
            Set-Variable -Name $ParameterName -Value $Parameters -Scope Global -Force

            if ($AllResults) {

                Write-Verbose "Gathering all items from [  $( $RocketCyberModuleBaseUri + $ResourceUri ) ] "

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
#EndRegion '.\Private\ApiCalls\Invoke-RocketCyberRequest.ps1' 191
#Region '.\Private\ApiKeys\Add-RocketCyberApiKey.ps1' -1

function Add-RocketCyberApiKey {
<#
    .SYNOPSIS
        Sets your API key used to authenticate all API calls

    .DESCRIPTION
        The Add-RocketCyberApiKey cmdlet sets your API key which is used to
        authenticate all API calls made to RocketCyber. Once the API key is
        defined, it is encrypted using SecureString

        The RocketCyber API keys are generated via the RocketCyber web interface
        at Provider Settings > RocketCyber API

    .PARAMETER ApiKey
        Plain text API key

        If not defined the cmdlet will prompt you to enter the API key which
        will be stored as a SecureString

    .PARAMETER ApiKeySecureString
        Input a SecureString object containing the API key

    .EXAMPLE
        Add-RocketCyberApiKey

        Prompts to enter in the API key

    .EXAMPLE
        Add-RocketCyberApiKey -ApiKey 'your_ApiKey'

        The RocketCyber API will use the string entered into the [ -ApiKey ] parameter

    .EXAMPLE
        '12345' | Add-RocketCyberApiKey

        The Add-RocketCyberApiKey function will use the string passed into it as its API key

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Add-RocketCyberApiKey.html
#>

    [CmdletBinding()]
    [alias( "Add-RCApiKey", "Set-RCApiKey", "Set-RocketCyberApiKey" )]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'AsPlainText')]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'SecureString')]
        [ValidateNotNullOrEmpty()]
        [securestring]$ApiKeySecureString
    )

    begin {}

    process {

        switch ($PSCmdlet.ParameterSetName) {

            'AsPlainText' {

                if ($ApiKey) {
                    $SecureString = ConvertTo-SecureString $ApiKey -AsPlainText -Force

                    Set-Variable -Name "RocketCyberModuleApiKey" -Value $SecureString -Option ReadOnly -Scope global -Force
                }
                else {
                    Write-Output "Please enter your API key:"
                    $SecureString = Read-Host -AsSecureString

                    Set-Variable -Name "RocketCyberModuleApiKey" -Value $SecureString -Option ReadOnly -Scope global -Force
                }

            }

            'SecureString' { Set-Variable -Name "RocketCyberModuleApiKey" -Value $ApiKeySecureString -Option ReadOnly -Scope global -Force }

        }

    }

    end {}
}
#EndRegion '.\Private\ApiKeys\Add-RocketCyberApiKey.ps1' 87
#Region '.\Private\ApiKeys\Get-RocketCyberApiKey.ps1' -1

function Get-RocketCyberApiKey {
<#
    .SYNOPSIS
        Gets the RocketCyber API key

    .DESCRIPTION
        The Get-RocketCyberApiKey cmdlet gets the RocketCyber API key
        global variable and returns it as a SecureString

    .PARAMETER AsPlainText
        Decrypt and return the API key in plain text

    .EXAMPLE
        Get-RocketCyberApiKey

        Gets the RocketCyber API key and returns it as a SecureString

    .EXAMPLE
        Get-RocketCyberApiKey -AsPlainText

        Gets and decrypts the API key from the global variable and
        returns the API key in plain text

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Get-RocketCyberApiKey.html
#>

    [CmdletBinding()]
    [alias( "Get-RCApiKey" )]
    Param (
        [Parameter(Mandatory = $false) ]
        [Switch]$AsPlainText
    )

    begin {}

    process {

        try {

            if ($RocketCyberModuleApiKey) {

                if ($AsPlainText) {
                    $ApiKey = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($RocketCyberModuleApiKey)
                    ( [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ApiKey) ).ToString()
                }
                else{$RocketCyberModuleApiKey}

            }
            else{
                Write-Warning 'The RocketCyber API key is not set. Run Add-RocketCyberApiKey to set the API key.'
            }
        }
        catch {
            Write-Error $_
        }
        finally {
            if ($ApiKey) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ApiKey)
            }
        }

    }

    end{}

}
#EndRegion '.\Private\ApiKeys\Get-RocketCyberApiKey.ps1' 71
#Region '.\Private\ApiKeys\Remove-RocketCyberApiKey.ps1' -1

function Remove-RocketCyberApiKey {
<#
    .SYNOPSIS
        Removes the RocketCyber API key

    .DESCRIPTION
        The Remove-RocketCyberApiKey cmdlet removes the RocketCyber API key

    .EXAMPLE
        Remove-RocketCyberApiKey

        Removes the RocketCyber API key

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Remove-RocketCyberApiKey.html
#>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    [alias("Remove-RCApiKey")]
    Param ()

    begin {}

    process {

        switch ([bool]$RocketCyberModuleApiKey) {
            $true   {
                if ($PSCmdlet.ShouldProcess('RocketCyberModuleApiKey')) {
                    Remove-Variable -Name 'RocketCyberModuleApiKey' -Scope Global -Force
                }
            }
            $false  { Write-Warning "The RocketCyber API key variable is not set. Nothing to remove" }
        }

    }

    end{}

}
#EndRegion '.\Private\ApiKeys\Remove-RocketCyberApiKey.ps1' 43
#Region '.\Private\ApiKeys\Test-RocketCyberApiKey.ps1' -1

function Test-RocketCyberApiKey {
<#
    .SYNOPSIS
        Test the RocketCyber API key

    .DESCRIPTION
        The Test-RocketCyberApiKey cmdlet tests the base URI & API
        key that was defined in the
        Add-RocketCyberBaseUri & Add-RocketCyberApiKey cmdlets

    .PARAMETER BaseUri
        Define the base URI for the RocketCyber API connection using RocketCyber's URI or a custom URI

        The default base URI is https://api-us.rocketcyber.com/v3

    .PARAMETER id
        Data will be retrieved from this account id

    .EXAMPLE
        Test-RocketCyberBaseUri -id 12345

        Tests the base URI & API key that was defined in the
        Add-RocketCyberBaseUri & Add-RocketCyberApiKey cmdlets

        The default full base uri test path is:
            https://api-us.rocketcyber.com/v3/account/id

    .EXAMPLE
        Test-RocketCyberBaseUri -BaseUri http://myapi.gateway.celerium.org -id 12345

        Tests the base URI & API key that was defined in the
        Add-RocketCyberBaseUri & Add-RocketCyberApiKey cmdlets

        The full base uri test path in this example is:
            http://myapi.gateway.celerium.org/id

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Test-RocketCyberApiKey.html
#>

    [CmdletBinding()]
    [alias("Test-RCApiKey")]
    Param (
        [Parameter(Mandatory = $false) ]
        [string]$BaseUri = $RocketCyberModuleBaseUri
    )

    begin { $ResourceUri = "/account" }

    process {

        Write-Verbose "Testing API key against [ $($BaseUri + $ResourceUri) ]"

        try {

            $ApiToken = Get-RocketCyberApiKey -AsPlainText

            $RocketCyberHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
            $RocketCyberHeaders.Add("Content-Type", 'application/json')
            $RocketCyberHeaders.Add('Authorization', "Bearer $ApiToken")

            $rest_output = Invoke-WebRequest -Method Get -Uri ($BaseUri + $ResourceUri) -Headers $RocketCyberHeaders -ErrorAction Stop
        }
        catch {

            [PSCustomObject]@{
                Method              = $_.Exception.Response.Method
                StatusCode          = $_.Exception.Response.StatusCode.value__
                StatusDescription   = $_.Exception.Response.StatusDescription
                Message             = $_.Exception.Message
                URI                 = $($BaseUri + $ResourceUri)
            }

        } finally {
            Remove-Variable -Name 'RocketCyberHeaders' -Force
        }

        if ($rest_output) {
            $data = @{}
            $data = $rest_output

            [PSCustomObject]@{
                StatusCode          = $data.StatusCode
                StatusDescription   = $data.StatusDescription
                URI                 = $($BaseUri + $ResourceUri)
            }
        }

    }

    end {}

}
#EndRegion '.\Private\ApiKeys\Test-RocketCyberApiKey.ps1' 97
#Region '.\Private\BaseUri\Add-RocketCyberBaseUri.ps1' -1

function Add-RocketCyberBaseUri {
<#
    .SYNOPSIS
        Sets the base URI for the RocketCyber API connection

    .DESCRIPTION
        The Add-RocketCyberBaseUri cmdlet sets the base URI which is later used
        to construct the full URI for all API calls

    .PARAMETER BaseUri
        Define the base URI for the RocketCyber API connection using
        RocketCyber's URI or a custom URI

    .PARAMETER DataCenter
        RocketCyber's URI connection point that can be one of the predefined data centers

        The accepted values for this parameter are:
        [ US, EU ]
        US = https://api-us.rocketcyber.com/v3
        EU = https://api-eu.rocketcyber.com/v3

    .EXAMPLE
        Add-RocketCyberBaseUri

        The base URI will use https://api-us.rocketcyber.com/v3 which is RocketCyber's default URI

    .EXAMPLE
        Add-RocketCyberBaseUri -DataCenter EU

        The base URI will use https://api-eu.rocketcyber.com/v3 which is RocketCyber's Europe URI

    .EXAMPLE
        Add-RocketCyberBaseUri -BaseUri http://myapi.gateway.celerium.org

        A custom API gateway of http://myapi.gateway.celerium.org will be used for
        all API calls to RocketCyber's API

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Add-RocketCyberBaseUri.html
#>

    [CmdletBinding()]
    [alias( "Add-RCBaseUri", "Set-RCBaseUri", "Set-RocketCyberBaseUri" )]
    Param (
        [Parameter(Mandatory = $false , ValueFromPipeline = $true)]
        [string]$BaseUri = 'https://api-us.rocketcyber.com/v3',

        [Parameter(Mandatory = $false) ]
        [ValidateSet( 'US', 'EU' )]
        [String]$DataCenter
    )

    begin {}

    process {

        if ($BaseUri[$BaseUri.Length-1] -eq "/") {
            $BaseUri = $BaseUri.Substring(0,$BaseUri.Length-1)
        }

        switch ($DataCenter) {
            'US' { $BaseUri = "https://api-us.rocketcyber.com/v3" }
            'EU' { $BaseUri = "https://api-eu.rocketcyber.com/v3" }
            Default {}
        }

        Set-Variable -Name 'RocketCyberModuleBaseUri' -Value $BaseUri -Option ReadOnly -Scope Global -Force

    }

    end {}
}
#EndRegion '.\Private\BaseUri\Add-RocketCyberBaseUri.ps1' 76
#Region '.\Private\BaseUri\Get-RocketCyberBaseUri.ps1' -1

function Get-RocketCyberBaseUri {
<#
    .SYNOPSIS
        Shows the RocketCyber base URI global variable

    .DESCRIPTION
        The Get-RocketCyberBaseUri cmdlet shows the RocketCyber base URI global variable value

    .EXAMPLE
        Get-RocketCyberBaseUri

        Shows the RocketCyber base URI global variable value

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Get-RocketCyberBaseUri.html
#>

    [CmdletBinding()]
    [alias("Get-RCBaseUri")]
    Param ()

    begin {}

    process {

        switch ([bool]$RocketCyberModuleBaseUri) {
            $true   { $RocketCyberModuleBaseUri }
            $false  { Write-Warning "The RocketCyber base URI is not set. Run Add-RocketCyberBaseUri to set the base URI." }
        }

    }

    end {}
}
#EndRegion '.\Private\BaseUri\Get-RocketCyberBaseUri.ps1' 38
#Region '.\Private\BaseUri\Remove-RocketCyberBaseUri.ps1' -1

function Remove-RocketCyberBaseUri {
<#
    .SYNOPSIS
        Removes the RocketCyber base URI global variable

    .DESCRIPTION
        The Remove-RocketCyberBaseUri cmdlet removes the RocketCyber base URI global variable

    .EXAMPLE
        Remove-RocketCyberBaseUri

        Removes the RocketCyber base URI global variable

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Remove-RocketCyberBaseUri.html
#>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    [alias("Remove-RCBaseUri")]
    Param ()

    begin {}

    process {

        switch ([bool]$RocketCyberModuleBaseUri) {
            $true   {
                if ($PSCmdlet.ShouldProcess('RocketCyberModuleBaseUri')) {
                    Remove-Variable -Name "RocketCyberModuleBaseUri" -Scope Global -Force
                }
            }
            $false  { Write-Warning "The RocketCyber base URI variable is not set. Nothing to remove" }
        }

    }

    end {}

}
#EndRegion '.\Private\BaseUri\Remove-RocketCyberBaseUri.ps1' 43
#Region '.\Private\ModuleSettings\Export-RocketCyberModuleSettings.ps1' -1

function Export-RocketCyberModuleSettings {
<#
    .SYNOPSIS
        Exports the RocketCyber BaseUri, API, & JSON configuration information to file

    .DESCRIPTION
        The Export-RocketCyberModuleSettings cmdlet exports the RocketCyber BaseUri, API, & JSON configuration information to file

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal
        This means that you cannot copy your configuration file to another computer or user account and expect it to work

    .PARAMETER RocketCyberConfigPath
        Define the location to store the RocketCyber configuration file

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\Celerium.RocketCyber

    .PARAMETER RocketCyberConfigFile
        Define the name of the RocketCyber configuration file

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Export-RocketCyberModuleSettings

        Validates that the BaseUri, API, and JSON depth are set then exports their values
        to the current user's RocketCyber configuration file located at:
            $env:USERPROFILE\Celerium.RocketCyber\config.psd1

    .EXAMPLE
        Export-RocketCyberModuleSettings -RocketCyberConfigPath C:\Celerium.RocketCyber -RocketCyberConfigFile MyConfig.psd1

        Validates that the BaseUri, API, and JSON depth are set then exports their values
        to the current user's RocketCyber configuration file located at:
            C:\Celerium.RocketCyber\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Export-RocketCyberModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Set')]
    [alias("Export-RCModuleSettings")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Set')]
        [string]$RocketCyberConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.RocketCyber"}else{".Celerium.RocketCyber"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'Set')]
        [string]$RocketCyberConfigFile = 'config.psd1'
    )

    begin {}

    process {

        Write-Warning "Secrets are stored using Windows Data Protection API (DPAPI)"
        Write-Warning "DPAPI provides user context encryption in Windows but NOT in other operating systems like Linux or UNIX. It is recommended to use a more secure & cross-platform storage method"

        $RocketCyberConfig = Join-Path -Path $RocketCyberConfigPath -ChildPath $RocketCyberConfigFile

        # Confirm variables exist and are not null before exporting
        if ($RocketCyberModuleBaseUri -and $RocketCyberModuleApiKey) {
            $SecureString = $RocketCyberModuleApiKey | ConvertFrom-SecureString

            if ($IsWindows -or $PSEdition -eq 'Desktop') {
                New-Item -Path $RocketCyberConfigPath -ItemType Directory -Force | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }
            }
            else{
                New-Item -Path $RocketCyberConfigPath -ItemType Directory -Force
            }
@"
    @{
        RocketCyberModuleBaseUri            = '$RocketCyberModuleBaseUri'
        RocketCyberModuleApiKey             = '$SecureString'
    }
"@ | Out-File -FilePath $RocketCyberConfig -Force
        }
        else {
            Write-Error "Failed to export RocketCyber module settings to [ $RocketCyberConfig ]"
            Write-Error $_
            exit 1
        }

    }

    end {}

}
#EndRegion '.\Private\ModuleSettings\Export-RocketCyberModuleSettings.ps1' 93
#Region '.\Private\ModuleSettings\Get-RocketCyberModuleSettings.ps1' -1

function Get-RocketCyberModuleSettings {
<#
    .SYNOPSIS
        Gets the saved RocketCyber configuration settings

    .DESCRIPTION
        The Get-RocketCyberModuleSettings cmdlet gets the saved RocketCyber configuration settings

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\Celerium.RocketCyber

    .PARAMETER RocketCyberConfigPath
        Define the location to store the RocketCyber configuration file

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\Celerium.RocketCyber

    .PARAMETER RocketCyberConfigFile
        Define the name of the RocketCyber configuration file

        By default the configuration file is named:
            config.psd1

    .PARAMETER OpenConfFile
        Opens the RocketCyber configuration file

    .EXAMPLE
        Get-RocketCyberModuleSettings

        Gets the contents of the configuration file that was created with the
        Export-RocketCyberModuleSettings

        The default location of the RocketCyber configuration file is:
            $env:USERPROFILE\Celerium.RocketCyber\config.psd1

    .EXAMPLE
        Get-RocketCyberModuleSettings -RocketCyberConfigPath C:\Celerium.RocketCyber -RocketCyberConfigFile MyConfig.psd1 -OpenConfFile

        Opens the configuration file from the defined location in the default editor

        The location of the RocketCyber configuration file in this example is:
            C:\Celerium.RocketCyber\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Get-RocketCyberModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    [alias("Export-RCModuleSettings")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Index')]
        [String]$RocketCyberConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.RocketCyber"}else{".Celerium.RocketCyber"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'Index')]
        [String]$RocketCyberConfigFile = 'config.psd1',

        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [Switch]$OpenConfFile
    )

    begin {
        $RocketCyberConfig = Join-Path -Path $RocketCyberConfigPath -ChildPath $RocketCyberConfigFile
    }

    process {

        if ( Test-Path -Path $RocketCyberConfig ) {

            if($OpenConfFile) {
                Invoke-Item -Path $RocketCyberConfig
            }
            else{
                Import-LocalizedData -BaseDirectory $RocketCyberConfigPath -FileName $RocketCyberConfigFile
            }

        }
        else {
            Write-Verbose "No configuration file found at [ $RocketCyberConfig ]"
        }

    }

    end{}

}
#EndRegion '.\Private\ModuleSettings\Get-RocketCyberModuleSettings.ps1' 89
#Region '.\Private\ModuleSettings\Import-RocketCyberModuleSettings.ps1' -1

function Import-RocketCyberModuleSettings {
<#
    .SYNOPSIS
        Imports the RocketCyber BaseUri, API, & JSON configuration information to the current session

    .DESCRIPTION
        The Import-RocketCyberModuleSettings cmdlet imports the RocketCyber BaseUri, API, & JSON configuration
        information stored in the RocketCyber configuration file to the users current session

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\Celerium.RocketCyber

    .PARAMETER RocketCyberConfigPath
        Define the location to store the RocketCyber configuration file

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\Celerium.RocketCyber

    .PARAMETER RocketCyberConfigFile
        Define the name of the RocketCyber configuration file

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Import-RocketCyberModuleSettings

        Validates that the configuration file created with the Export-RocketCyberModuleSettings cmdlet exists
        then imports the stored data into the current users session

        The default location of the RocketCyber configuration file is:
            $env:USERPROFILE\Celerium.RocketCyber\config.psd1

    .EXAMPLE
        Import-RocketCyberModuleSettings -RocketCyberConfigPath C:\Celerium.RocketCyber -RocketCyberConfigFile MyConfig.psd1

        Validates that the configuration file created with the Export-RocketCyberModuleSettings cmdlet exists
        then imports the stored data into the current users session

        The location of the RocketCyber configuration file in this example is:
            C:\Celerium.RocketCyber\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Import-RocketCyberModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Set')]
    [alias("Import-RCModuleSettings")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Set')]
        [string]$RocketCyberConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.RocketCyber"}else{".Celerium.RocketCyber"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'Set')]
        [string]$RocketCyberConfigFile = 'config.psd1'
    )

    begin {
        $RocketCyberConfig = Join-Path -Path $RocketCyberConfigPath -ChildPath $RocketCyberConfigFile
    }

    process {

        if ( Test-Path $RocketCyberConfig ) {
            $TempConfig = Import-LocalizedData -BaseDirectory $RocketCyberConfigPath -FileName $RocketCyberConfigFile

                # Send to function to strip potentially superfluous slash (/)
                Add-RocketCyberBaseUri $TempConfig.RocketCyberModuleBaseUri

                $TempConfig.RocketCyberModuleApiKey = ConvertTo-SecureString $TempConfig.RocketCyberModuleApiKey

                Set-Variable -Name 'RocketCyberModuleBaseUri' -Value $TempConfig.RocketCyberModuleBaseUri -Option ReadOnly -Scope Global -Force

                Set-Variable -Name 'RocketCyberModuleApiKey' -Value $TempConfig.RocketCyberModuleApiKey -Option ReadOnly -Scope Global -Force

            Write-Verbose "The Celerium.RocketCyber Module configuration loaded successfully from [ $RocketCyberConfig ]"

            # Clean things up
            Remove-Variable "TempConfig"
        }
        else {
            Write-Verbose "No configuration file found at [ $RocketCyberConfig ] run Add-RocketCyberApiKey & Add-RocketCyberBaseUri to get started."

            Add-RocketCyberBaseUri

            Set-Variable -Name "RocketCyberModuleBaseUri" -Value $(Get-RocketCyberBaseUri) -Option ReadOnly -Scope Global -Force
        }

    }

    end {}

}
#EndRegion '.\Private\ModuleSettings\Import-RocketCyberModuleSettings.ps1' 96
#Region '.\Private\ModuleSettings\Initialize-RocketCyberModuleSettings.ps1' -1

#Used to auto load either baseline settings or saved configurations when the module is imported
Import-RocketCyberModuleSettings -Verbose:$false
#EndRegion '.\Private\ModuleSettings\Initialize-RocketCyberModuleSettings.ps1' 3
#Region '.\Private\ModuleSettings\Remove-RocketCyberModuleSettings.ps1' -1

function Remove-RocketCyberModuleSettings {
<#
    .SYNOPSIS
        Removes the stored RocketCyber configuration folder

    .DESCRIPTION
        The Remove-RocketCyberModuleSettings cmdlet removes the RocketCyber folder and its files
        This cmdlet also has the option to remove sensitive RocketCyber variables as well

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\Celerium.RocketCyber

    .PARAMETER RocketCyberConfigPath
        Define the location of the RocketCyber configuration folder

        By default the configuration folder is located at:
            $env:USERPROFILE\Celerium.RocketCyber

    .PARAMETER AndVariables
        Define if sensitive RocketCyber variables should be removed as well

        By default the variables are not removed

    .EXAMPLE
        Remove-RocketCyberModuleSettings

        Checks to see if the default configuration folder exists and removes it if it does

        The default location of the RocketCyber configuration folder is:
            $env:USERPROFILE\Celerium.RocketCyber

    .EXAMPLE
        Remove-RocketCyberModuleSettings -RocketCyberConfigPath C:\Celerium.RocketCyber -AndVariables

        Checks to see if the defined configuration folder exists and removes it if it does
        If sensitive RocketCyber variables exist then they are removed as well

        The location of the RocketCyber configuration folder in this example is:
            C:\Celerium.RocketCyber

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Celerium.RocketCyber/site/Internal/Remove-RocketCyberModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess)]
    [alias("Remove-RCModuleSettings")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Destroy')]
        [string]$RocketCyberConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.RocketCyber"}else{".Celerium.RocketCyber"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'Destroy')]
        [switch]$AndVariables
    )

    begin {}

    process {

        if(Test-Path $RocketCyberConfigPath)  {

            Remove-Item -Path $RocketCyberConfigPath -Recurse -Force -WhatIf:$WhatIfPreference

            If ($AndVariables) {
                Remove-RocketCyberApiKey
                Remove-RocketCyberBaseUri
            }

            if ($WhatIfPreference -eq $false) {

                if (!(Test-Path $RocketCyberConfigPath)) {
                    Write-Output "The Celerium.RocketCyber configuration folder has been removed successfully from [ $RocketCyberConfigPath ]"
                }
                else {
                    Write-Error "The Celerium.RocketCyber configuration folder could not be removed from [ $RocketCyberConfigPath ]"
                }

            }

        }
        else {
            Write-Warning "No configuration folder found at [ $RocketCyberConfigPath ]"
        }

    }

    end {}

}
#EndRegion '.\Private\ModuleSettings\Remove-RocketCyberModuleSettings.ps1' 92
#Region '.\Public\Account\Get-RocketCyberAccount.ps1' -1

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
#EndRegion '.\Public\Account\Get-RocketCyberAccount.ps1' 88
#Region '.\Public\Agents\Get-RocketCyberAgent.ps1' -1

function Get-RocketCyberAgent {
<#
    .SYNOPSIS
        Gets RocketCyber agents from an account

    .DESCRIPTION
        The Get-RocketCyberAgent cmdlet gets all the device information
        for all devices associated to the account ID provided.

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

            $CreatedQuery = "$StartTime | $EndTime"
            $UriParameters['created']     = $CreatedQuery

            <#
                if ([bool]$StartDate -eq $true -and [bool]$EndDate -eq $true) {
                    $CreatedQuery = $StartTime + '|' + $EndTime
                }
                elseif ([bool]$StartDate -eq $true -and [bool]$EndDate -eq $false) {
                    $CreatedQuery = $StartTime + '|'
                }
                else{
                    $CreatedQuery = '|' + $EndTime
                }
            #>

        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-RocketCyberRequest -Method GET -ResourceUri $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end{}

}
#EndRegion '.\Public\Agents\Get-RocketCyberAgent.ps1' 278
#Region '.\Public\Apps\Get-RocketCyberApp.ps1' -1

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
        [Parameter(Mandatory = $false)]
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
#EndRegion '.\Public\Apps\Get-RocketCyberApp.ps1' 95
#Region '.\Public\Defender\Get-RocketCyberDefender.ps1' -1

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
#EndRegion '.\Public\Defender\Get-RocketCyberDefender.ps1' 77
#Region '.\Public\Events\Get-RocketCyberEvent.ps1' -1

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

        [Parameter(Mandatory = $false, ParameterSetName = 'IndexByEvent')]
        [Parameter(Mandatory = $false, ParameterSetName = 'IndexByEventSummary')]
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

        return Invoke-RocketCyberRequest -Method GET -ResourceUri $ResourceUri -UriFilter $UriParameters

    }

    end{}

}
#EndRegion '.\Public\Events\Get-RocketCyberEvent.ps1' 199
#Region '.\Public\Firewalls\Get-RocketCyberFirewall.ps1' -1

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
#EndRegion '.\Public\Firewalls\Get-RocketCyberFirewall.ps1' 180
#Region '.\Public\Incidents\Get-RocketCyberIncident.ps1' -1

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
        https://celerium.github.io/Celerium.RocketCyber/site/Incidents/Get-RocketCyberIncident.html

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
#EndRegion '.\Public\Incidents\Get-RocketCyberIncident.ps1' 247
#Region '.\Public\Office\Get-RocketCyberOffice.ps1' -1

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
        [Int64]$AccountId

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
#EndRegion '.\Public\Office\Get-RocketCyberOffice.ps1' 81
