---
external help file: Celerium.RocketCyber-help.xml
grand_parent: Internal
Module Name: Celerium.RocketCyber
online version: https://celerium.github.io/Celerium.RocketCyber/site/Internal/Get-RocketCyberApiKey.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberApiKey
---

# Get-RocketCyberApiKey

## SYNOPSIS
Gets the RocketCyber API key

## SYNTAX

```powershell
Get-RocketCyberApiKey [-AsPlainText] [<CommonParameters>]
```

## DESCRIPTION
The Get-RocketCyberApiKey cmdlet gets the RocketCyber API key
global variable and returns it as a SecureString

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberApiKey
```

Gets the RocketCyber API key and returns it as a SecureString

### EXAMPLE 2
```powershell
Get-RocketCyberApiKey -AsPlainText
```

Gets and decrypts the API key from the global variable and
returns the API key in plain text

## PARAMETERS

### -AsPlainText
Decrypt and return the API key in plain text

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/Celerium.RocketCyber/site/Internal/Get-RocketCyberApiKey.html](https://celerium.github.io/Celerium.RocketCyber/site/Internal/Get-RocketCyberApiKey.html)

