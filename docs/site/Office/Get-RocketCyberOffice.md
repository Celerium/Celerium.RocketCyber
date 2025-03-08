---
external help file: Celerium.RocketCyber-help.xml
grand_parent: Office
Module Name: Celerium.RocketCyber
online version: https://celerium.github.io/Celerium.RocketCyber/site/Office/Get-RocketCyberOffice.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberOffice
---

# Get-RocketCyberOffice

## SYNOPSIS
Gets office information from the RocketCyber API

## SYNTAX

```powershell
Get-RocketCyberOffice [[-AccountId] <Int64>] [<CommonParameters>]
```

## DESCRIPTION
The Get-RocketCyberOffice cmdlet gets office information
from all or a defined AccountId

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberOffice
```

Office data will be retrieved from all accounts accessible
by the key

### EXAMPLE 2
```powershell
Get-RocketCyberOffice -AccountId 12345
```

Office data will be retrieved from the AccountId 12345

### EXAMPLE 3
```powershell
12345 | Get-RocketCyberOffice
```

Office data will be retrieved from the AccountId 12345

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
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/Celerium.RocketCyber/site/Office/Get-RocketCyberOffice.html](https://celerium.github.io/Celerium.RocketCyber/site/Office/Get-RocketCyberOffice.html)

