---
external help file: Celerium.RocketCyber-help.xml
grand_parent: Incidents
Module Name: Celerium.RocketCyber
online version: https://celerium.github.io/Celerium.RocketCyber/site/Incidents/Get-RocketCyberIncident.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberIncident
---

# Get-RocketCyberIncident

## SYNOPSIS
Gets incident information from the RocketCyber API

## SYNTAX

```powershell
Get-RocketCyberIncident [[-ID] <Int32[]>] [[-Title] <String[]>] [[-AccountId] <Int64[]>]
 [[-Description] <String[]>] [[-Remediation] <String>] [[-ResolvedAt] <String>] [[-CreatedAt] <String>]
 [[-Status] <String[]>] [[-Page] <Int32>] [[-PageSize] <Int32>] [[-Sort] <String>] [-AllResults]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-RocketCyberIncident cmdlet gets incident information
associated to all or a defined account ID

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberIncident
```

Gets the first 1000 incidents from all accounts accessible
by the key

### EXAMPLE 2
```powershell
Get-RocketCyberIncident -AccountId 12345 -Id 9876
```

Gets the defined incident Id from the defined AccountId

### EXAMPLE 3
```powershell
Get-RocketCyberIncident -Title nmap -ResolvedAt '2023-01-01|'
```

Gets the first 1000 incidents from all accounts accessible
by the key that were resolved after the defined
startDate with the defined word in the title

### EXAMPLE 4
```powershell
Get-RocketCyberIncident -Description audit -CreatedAt '|2023-03-01'
```

Gets the first 1000 incidents from all accounts accessible
by the key that were created before the defined
endDate with the defined word in the description

### EXAMPLE 5
```powershell
Get-RocketCyberIncident -status resolved -sort title:asc
```

Gets the first 1000 resolved incidents from all accounts accessible
by the key and the data is return by title in
ascending order

## PARAMETERS

### -ID
The RocketCyber incident ID

Multiple comma separated values can be inputted

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
The title of the incident

Example:
    Office*

Multiple comma separated values can be inputted

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Description
The description of the incident

NOTE: Wildcards are required to search for specific text

Example:
    administrative

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Remediation
The remediation for the incident

NOTE: Wildcards are required to search for specific text

Example:
    permission*

As of 2023-03 this parameters does not appear to work

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResolvedAt
This returns incidents resolved between the start and end date

Both the start and end dates are optional, but at least one is
required to use this parameter

Start Time  |  End Time

Example:
    2022-05-09  |2022-05-10
    2022-05-09  |
                |2022-05-10

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreatedAt
This returns incidents created between the start and end date

Both the start and end dates are optional, but at least one is
required to use this parameter

Start Time  |  End Time

Example:
    2022-05-09  |2022-05-10
    2022-05-09  |
                |2022-05-10

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
The type of incidents to request

Allowed Values:
    'open', 'resolved'

As of 2023-03 the documentation defines the
allowed values listed below but not all work

'all', 'open', 'closed'

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
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
Position: 9
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
Position: 10
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sort
The sort order for the items queried

Not all values can be sorted

Example:
    AccountId:asc
    title:desc

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
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
As of 2023-03:
    Any parameters that say wildcards are required is not valid

    Using wildcards in the query string do not work as the endpoint
    already search's via wildcard.
If you use a wildcard '*' it
    will not return any results

The remediation parameter does not appear to work

## RELATED LINKS

[https://celerium.github.io/Celerium.RocketCyber/site/Incident/Get-RocketCyberIncident.html](https://celerium.github.io/Celerium.RocketCyber/site/Incident/Get-RocketCyberIncident.html)

