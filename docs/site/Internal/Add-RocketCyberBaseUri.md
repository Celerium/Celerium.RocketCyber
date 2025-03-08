---
external help file: Celerium.RocketCyber-help.xml
grand_parent: Internal
Module Name: Celerium.RocketCyber
online version: https://celerium.github.io/Celerium.RocketCyber/site/Internal/Add-RocketCyberBaseUri.html
parent: POST
schema: 2.0.0
title: Add-RocketCyberBaseUri
---

# Add-RocketCyberBaseUri

## SYNOPSIS
Sets the base URI for the RocketCyber API connection

## SYNTAX

```powershell
Add-RocketCyberBaseUri [[-BaseUri] <String>] [[-DataCenter] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Add-RocketCyberBaseUri cmdlet sets the base URI which is later used
to construct the full URI for all API calls

## EXAMPLES

### EXAMPLE 1
```powershell
Add-RocketCyberBaseUri
```

The base URI will use https://api-us.rocketcyber.com/v3 which is RocketCyber's default URI

### EXAMPLE 2
```powershell
Add-RocketCyberBaseUri -DataCenter EU
```

The base URI will use https://api-eu.rocketcyber.com/v3 which is RocketCyber's Europe URI

### EXAMPLE 3
```powershell
Add-RocketCyberBaseUri -BaseUri http://myapi.gateway.celerium.org
```

A custom API gateway of http://myapi.gateway.celerium.org will be used for
all API calls to RocketCyber's API

## PARAMETERS

### -BaseUri
Define the base URI for the RocketCyber API connection using
RocketCyber's URI or a custom URI

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Https://api-us.rocketcyber.com/v3
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -DataCenter
RocketCyber's URI connection point that can be one of the predefined data centers

The accepted values for this parameter are:
\[ US, EU \]
US = https://api-us.rocketcyber.com/v3
EU = https://api-eu.rocketcyber.com/v3

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

[https://celerium.github.io/Celerium.RocketCyber/site/Internal/Add-RocketCyberBaseUri.html](https://celerium.github.io/Celerium.RocketCyber/site/Internal/Add-RocketCyberBaseUri.html)

