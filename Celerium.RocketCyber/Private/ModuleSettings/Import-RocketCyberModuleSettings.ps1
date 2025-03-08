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