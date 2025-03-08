---
external help file: Celerium.RocketCyber-help.xml
grand_parent: Internal
Module Name: Celerium.RocketCyber
online version: https://celerium.github.io/Celerium.RocketCyber/site/Internal/Remove-RocketCyberModuleSettings.html
parent: DELETE
schema: 2.0.0
title: Remove-RocketCyberModuleSettings
---

# Remove-RocketCyberModuleSettings

## SYNOPSIS
Removes the stored RocketCyber configuration folder

## SYNTAX

```powershell
Remove-RocketCyberModuleSettings [-RocketCyberConfigPath <String>] [-AndVariables] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-RocketCyberModuleSettings cmdlet removes the RocketCyber folder and its files
This cmdlet also has the option to remove sensitive RocketCyber variables as well

By default configuration files are stored in the following location and will be removed:
    $env:USERPROFILE\Celerium.RocketCyber

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-RocketCyberModuleSettings
```

Checks to see if the default configuration folder exists and removes it if it does

The default location of the RocketCyber configuration folder is:
    $env:USERPROFILE\Celerium.RocketCyber

### EXAMPLE 2
```powershell
Remove-RocketCyberModuleSettings -RocketCyberConfigPath C:\Celerium.RocketCyber -AndVariables
```

Checks to see if the defined configuration folder exists and removes it if it does
If sensitive RocketCyber variables exist then they are removed as well

The location of the RocketCyber configuration folder in this example is:
    C:\Celerium.RocketCyber

## PARAMETERS

### -RocketCyberConfigPath
Define the location of the RocketCyber configuration folder

By default the configuration folder is located at:
    $env:USERPROFILE\Celerium.RocketCyber

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.RocketCyber"}else{".Celerium.RocketCyber"}) )
Accept pipeline input: False
Accept wildcard characters: False
```

### -AndVariables
Define if sensitive RocketCyber variables should be removed as well

By default the variables are not removed

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
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

[https://celerium.github.io/Celerium.RocketCyber/site/Internal/Remove-RocketCyberModuleSettings.html](https://celerium.github.io/Celerium.RocketCyber/site/Internal/Remove-RocketCyberModuleSettings.html)

