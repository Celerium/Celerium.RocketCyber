---
external help file: Celerium.RocketCyber-help.xml
grand_parent: Internal
Module Name: Celerium.RocketCyber
online version: https://celerium.github.io/Celerium.RocketCyber/site/Internal/Test-RocketCyberApiKey.html
parent: GET
schema: 2.0.0
title: Test-RocketCyberApiKey
---

# Test-RocketCyberApiKey

## SYNOPSIS
Test the RocketCyber API key

## SYNTAX

```powershell
Test-RocketCyberApiKey [[-BaseUri] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Test-RocketCyberApiKey cmdlet tests the base URI & API
key that was defined in the
Add-RocketCyberBaseUri & Add-RocketCyberApiKey cmdlets

## EXAMPLES

### EXAMPLE 1
```powershell
Test-RocketCyberBaseUri -id 12345
```

Tests the base URI & API key that was defined in the
Add-RocketCyberBaseUri & Add-RocketCyberApiKey cmdlets

The default full base uri test path is:
    https://api-us.rocketcyber.com/v3/account/id

### EXAMPLE 2
```powershell
Test-RocketCyberBaseUri -BaseUri http://myapi.gateway.celerium.org -id 12345
```

Tests the base URI & API key that was defined in the
Add-RocketCyberBaseUri & Add-RocketCyberApiKey cmdlets

The full base uri test path in this example is:
    http://myapi.gateway.celerium.org/id

## PARAMETERS

### -BaseUri
Define the base URI for the RocketCyber API connection using RocketCyber's URI or a custom URI

The default base URI is https://api-us.rocketcyber.com/v3

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $RocketCyberModuleBaseUri
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

[https://celerium.github.io/Celerium.RocketCyber/site/Internal/Test-RocketCyberApiKey.html](https://celerium.github.io/Celerium.RocketCyber/site/Internal/Test-RocketCyberApiKey.html)

