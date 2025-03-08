---
external help file: Celerium.RocketCyber-help.xml
grand_parent: Apps
Module Name: Celerium.RocketCyber
online version: https://celerium.github.io/Celerium.RocketCyber/site/Apps/Get-RocketCyberApp.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberApp
---

# Get-RocketCyberApp

## SYNOPSIS
Gets an accounts apps from the RocketCyber API

## SYNTAX

```powershell
Get-RocketCyberApp [[-AccountId] <Int64>] [[-Status] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Get-RocketCyberApp cmdlet gets an accounts apps
from the RocketCyber API

Can be used with the Get-RocketCyberEvent cmdlet

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberApp
```

Gets active apps from accounts accessible
by the key

### EXAMPLE 2
```powershell
Get-RocketCyberApp -AccountId 12345
```

Gets active apps from account 12345

### EXAMPLE 3
```powershell
Get-RocketCyberApp -AccountId 12345 -status inactive
```

Gets inactive apps from account 12345

## PARAMETERS

### -AccountId
The account ID to pull data for

If not provided, data will be pulled for all accounts
accessible by the key

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
The type of apps to request

Acceptable values are:
    'active', 'inactive'

The default value is 'active'

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

[https://celerium.github.io/Celerium.RocketCyber/site/Apps/Get-RocketCyberApp.html](https://celerium.github.io/Celerium.RocketCyber/site/Apps/Get-RocketCyberApp.html)

