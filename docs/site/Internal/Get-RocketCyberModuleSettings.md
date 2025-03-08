---
external help file: Celerium.RocketCyber-help.xml
grand_parent: Internal
Module Name: Celerium.RocketCyber
online version: https://celerium.github.io/Celerium.RocketCyber/site/Internal/Get-RocketCyberModuleSettings.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberModuleSettings
---

# Get-RocketCyberModuleSettings

## SYNOPSIS
Gets the saved RocketCyber configuration settings

## SYNTAX

### Index (Default)
```powershell
Get-RocketCyberModuleSettings [-RocketCyberConfigPath <String>] [-RocketCyberConfigFile <String>]
 [<CommonParameters>]
```

### Show
```powershell
Get-RocketCyberModuleSettings [-OpenConfFile] [<CommonParameters>]
```

## DESCRIPTION
The Get-RocketCyberModuleSettings cmdlet gets the saved RocketCyber configuration settings

By default the configuration file is stored in the following location:
    $env:USERPROFILE\Celerium.RocketCyber

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberModuleSettings
```

Gets the contents of the configuration file that was created with the
Export-RocketCyberModuleSettings

The default location of the RocketCyber configuration file is:
    $env:USERPROFILE\Celerium.RocketCyber\config.psd1

### EXAMPLE 2
```powershell
Get-RocketCyberModuleSettings -RocketCyberConfigPath C:\Celerium.RocketCyber -RocketCyberConfigFile MyConfig.psd1 -OpenConfFile
```

Opens the configuration file from the defined location in the default editor

The location of the RocketCyber configuration file in this example is:
    C:\Celerium.RocketCyber\MyConfig.psd1

## PARAMETERS

### -RocketCyberConfigPath
Define the location to store the RocketCyber configuration file

By default the configuration file is stored in the following location:
    $env:USERPROFILE\Celerium.RocketCyber

```yaml
Type: String
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.RocketCyber"}else{".Celerium.RocketCyber"}) )
Accept pipeline input: False
Accept wildcard characters: False
```

### -RocketCyberConfigFile
Define the name of the RocketCyber configuration file

By default the configuration file is named:
    config.psd1

```yaml
Type: String
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: Config.psd1
Accept pipeline input: False
Accept wildcard characters: False
```

### -OpenConfFile
Opens the RocketCyber configuration file

```yaml
Type: SwitchParameter
Parameter Sets: Show
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/Celerium.RocketCyber/site/Internal/Get-RocketCyberModuleSettings.html](https://celerium.github.io/Celerium.RocketCyber/site/Internal/Get-RocketCyberModuleSettings.html)

