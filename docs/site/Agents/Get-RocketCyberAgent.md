---
external help file: Celerium.RocketCyber-help.xml
grand_parent: Agents
Module Name: Celerium.RocketCyber
online version: https://celerium.github.io/Celerium.RocketCyber/site/Agents/Get-RocketCyberAgent.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberAgent
---

# Get-RocketCyberAgent

## SYNOPSIS
Gets RocketCyber agents from an account

## SYNTAX

### Index (Default)
```powershell
Get-RocketCyberAgent [-AccountId <Int64[]>] [-ID <String[]>] [-Hostname <String[]>] [-IP <String[]>]
 [-Created <String>] [-OS <String>] [-Version <String>] [-Connectivity <String[]>] [-Page <Int32>]
 [-PageSize <Int32>] [-Sort <String>] [-AllResults] [<CommonParameters>]
```

### IndexByCustomTime
```powershell
Get-RocketCyberAgent [-AccountId <Int64[]>] [-ID <String[]>] [-Hostname <String[]>] [-IP <String[]>]
 [-StartDate <DateTime>] [-EndDate <DateTime>] [-OS <String>] [-Version <String>] [-Connectivity <String[]>]
 [-Page <Int32>] [-PageSize <Int32>] [-Sort <String>] [-AllResults] [<CommonParameters>]
```

## DESCRIPTION
The Get-RocketCyberAgent cmdlet gets all the device information
for all devices associated to the account ID provided.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberAgent
```

Gets the first 1000 agents from all accounts accessible
by the key

### EXAMPLE 2
```powershell
Get-RocketCyberAgent -ID 12345
```

Gets the first 1000 agents from account 12345

### EXAMPLE 3
```powershell
Get-RocketCyberAgent -ID 12345 -sort hostname:asc
```

Gets the first 1000 agents from account 12345

Data is sorted by hostname and returned in ascending order

### EXAMPLE 4
```powershell
Get-RocketCyberAgent -ID 12345 -Connectivity offline,isolated
```

Gets the first 1000 offline agents from account 12345 that are
either offline or isolated

## PARAMETERS

### -AccountId
The account id associated to the device

If not provided, data will be pulled for all accounts
accessible by the key

Multiple comma separated values can be inputted

```yaml
Type: Int64[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ID
The agent id

Multiple comma separated values can be inputted

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hostname
The device hostname

Multiple comma separated values can be inputted

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IP
The IP address tied to the device

Multiple comma separated values can be inputted

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Created
The date range for when agents were created

Both the start and end dates are optional, but at least one is
required to use this parameter

Cannot be used with the StartDate & EndDate parameters

Start UTC Time | End UTC Time

Example:
    2022-05-09T00:33:38.245Z|2022-05-10T23:59:38.245Z
    2022-05-09T00:33:38.245Z|
                            |2022-05-10T23:59:38.245Z

```yaml
Type: String
Parameter Sets: Index
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
The friendly start date for when agents were created

Both the start and end dates are optional, but at least one is
required to use this parameter

Cannot be used with the created parameter

Date needs to be inputted as yyyy-mm-dd hh:mm:ss

```yaml
Type: DateTime
Parameter Sets: IndexByCustomTime
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
The friendly end date for when agents were created

Both the start and end dates are optional, but at least one is
required to use this parameter

Cannot be used with the created parameter

Date needs to be inputted as yyyy-mm-dd hh:mm:ss

```yaml
Type: DateTime
Parameter Sets: IndexByCustomTime
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OS
The OS used by the device

As of 2023-03 using * do not appear to work correctly

Example:
    Windows*
    Windows

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
The agent version

As of 2023-03 this filter appears not to work correctly

Example:
    Server 2019

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Connectivity
The connectivity status of the agent

Multiple comma separated values can be inputted

Allowed values:
    'online', 'offline', 'isolated'

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
The target page of data

This is used with pageSize parameter to determine how many
and which items to return

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
The number of items to return from the data set

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sort
The sort order for the items queried

Not all values can be sorted

Example:
    hostname:asc
    AccountId:desc

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllResults
Returns all items from an endpoint

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

[https://celerium.github.io/Celerium.RocketCyber/site/Agents/Get-RocketCyberAgent.html](https://celerium.github.io/Celerium.RocketCyber/site/Agents/Get-RocketCyberAgent.html)

