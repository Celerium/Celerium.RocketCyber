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
        if ($RocketCyberModuleBaseURI -and $RocketCyberModuleApiKey) {
            $SecureString = $RocketCyberModuleApiKey | ConvertFrom-SecureString

            if ($IsWindows -or $PSEdition -eq 'Desktop') {
                New-Item -Path $RocketCyberConfigPath -ItemType Directory -Force | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }
            }
            else{
                New-Item -Path $RocketCyberConfigPath -ItemType Directory -Force
            }
@"
    @{
        RocketCyberModuleBaseURI            = '$RocketCyberModuleBaseURI'
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