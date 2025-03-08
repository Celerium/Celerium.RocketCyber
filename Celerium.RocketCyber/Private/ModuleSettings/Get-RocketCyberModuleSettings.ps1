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