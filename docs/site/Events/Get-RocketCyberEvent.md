---
external help file: Celerium.RocketCyber-help.xml
grand_parent: Events
Module Name: Celerium.RocketCyber
online version: https://celerium.github.io/Celerium.RocketCyber/site/Events/Get-RocketCyberEvent.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberEvent
---

# Get-RocketCyberEvent

## SYNOPSIS
Gets app event information from the RocketCyber API

## SYNTAX

### IndexByEvent (Default)
```powershell
Get-RocketCyberEvent -AppId <Int32> [-Verdict <String[]>] [-AccountId <Int64[]>] [-Details <String>]
 [-Dates <String>] [-Page <Int32>] [-PageSize <Int32>] [-Sort <String>] [-AllResults] [<CommonParameters>]
```

### IndexByEventSummary
```powershell
Get-RocketCyberEvent [-AccountId <Int64[]>] [-EventSummary] [<CommonParameters>]
```

## DESCRIPTION
The Get-RocketCyberEvent cmdlet gets app event information for
events associated to all or a defined account ID

Use the Get-RockerCyberApp cmdlet to get app ids

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberEvent -AppId 7
```

Gets the first 1000 AppId 7 events from all accounts accessible
by the key

### EXAMPLE 2
```powershell
Get-RocketCyberEvent -AccountId 12345 -AppId 7
```

Gets the first 1000 AppId 7 events from account 12345

### EXAMPLE 3
```powershell
Get-RocketCyberEvent -AppId 7 -sort dates:desc
```

Gets the first 1000 AppId 7 events and the data set is sort
by dates in descending order

### EXAMPLE 4
```powershell
Get-RocketCyberEvent -AppId 7 -Verdict suspicious
```

Gets the first 1000 AppId 7 events and the data set is sort
by dates in descending order

## PARAMETERS

### -AppId
The app ID

```yaml
Type: Int32
Parameter Sets: IndexByEvent
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Verdict
The verdict of the event

Multiple comma separated values can be inputted

Allowed Values:
'informational', 'suspicious', 'malicious'

```yaml
Type: String[]
Parameter Sets: IndexByEvent
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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
Accept pipeline input: False
Accept wildcard characters: False
```

### -EventSummary
Shows summary of events for each app

```yaml
Type: SwitchParameter
Parameter Sets: IndexByEventSummary
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Details
This parameter allows users to target specific attributes within the Details object

This requires you to define the attribute path (period separated) and the expected value

The value can include wildcards (*)

Example: (AppId 7)
    attributes.direction:outbound

```yaml
Type: String
Parameter Sets: IndexByEvent
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Dates
The date range for event detections

Both the start and end dates are optional, but at least one is
required to use this parameter

Start Time | End Time

Example:
    2022-05-09  |2022-05-10
    2022-05-09  |
                |2022-05-10

```yaml
Type: String
Parameter Sets: IndexByEvent
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
Parameter Sets: IndexByEvent
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
Parameter Sets: IndexByEvent
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
    verdict:asc
    dates:desc

```yaml
Type: String
Parameter Sets: IndexByEvent
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
Parameter Sets: IndexByEvent
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
As of 2023-03
    Other than the parameters shown here, app specific parameters vary from app to app,
    however I have not found any documentation around this

## RELATED LINKS

[https://celerium.github.io/Celerium.RocketCyber/site/Events/Get-RocketCyberEvent.html](https://celerium.github.io/Celerium.RocketCyber/site/Events/Get-RocketCyberEvent.html)

