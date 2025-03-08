---
external help file: Celerium.RocketCyber-help.xml
grand_parent: Account
Module Name: Celerium.RocketCyber
online version: https://celerium.github.io/Celerium.RocketCyber/site/Account/Get-RocketCyberAccount.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberAccount
---

# Get-RocketCyberAccount

## SYNOPSIS
Gets account information for a given ID

## SYNTAX

```powershell
Get-RocketCyberAccount [[-AccountId] <Int64>] [-Details] [<CommonParameters>]
```

## DESCRIPTION
The Get-RocketCyberAccount cmdlet gets account information all
accounts or for a given ID from the RocketCyber API

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberAccount
```

Account data will be retrieved from all accounts accessible
by the key

### EXAMPLE 2
```powershell
Get-RocketCyberAccount -AccountId 12345
```

Account data will be retrieved for the account with the AccountId 12345

### EXAMPLE 3
```powershell
12345 | Get-RocketCyberAccount
```

Account data will be retrieved for the account with the AccountId 12345

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

### -Details
Should additional Details for each sub-accounts be displayed
in the return data

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

[https://celerium.github.io/Celerium.RocketCyber/site/Account/Get-RocketCyberAccount.html](https://celerium.github.io/Celerium.RocketCyber/site/Account/Get-RocketCyberAccount.html)

