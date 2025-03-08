---
external help file: Celerium.RocketCyber-help.xml
grand_parent: Firewalls
Module Name: Celerium.RocketCyber
online version: https://celerium.github.io/Celerium.RocketCyber/site/Firewalls/Get-RocketCyberFirewall.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberFirewall
---

# Get-RocketCyberFirewall

## SYNOPSIS
Gets RocketCyber firewalls from an account

## SYNTAX

```powershell
Get-RocketCyberFirewall [[-AccountId] <Int64[]>] [[-DeviceId] <String>] [[-IPAddress] <String>]
 [[-MACAddress] <String[]>] [[-Type] <String[]>] [-Counters] [[-Page] <Int32>] [[-PageSize] <Int32>]
 [[-Sort] <String>] [-AllResults] [<CommonParameters>]
```

## DESCRIPTION
The Get-RocketCyberFirewall cmdlet gets firewalls from
an account

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberFirewall
```

Gets the first 1000 agents from all accounts accessible
by the key

### EXAMPLE 2
```powershell
Get-RocketCyberFirewall -AccountId 12345
```

The first 1000 firewalls are pulled from AccountId 12345

### EXAMPLE 3
```powershell
Get-RocketCyberFirewall -MACAddress '11:22:33:aa:bb:cc'
```

Get the firewall with the defined MACAddress

### EXAMPLE 4
```powershell
Get-RocketCyberFirewall -Type SonicWall,Fortinet
```

Get firewalls with the defined type

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
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -DeviceId
The device ID tied to the device

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

### -IPAddress
The IP address tied to the device

As of 2023-03 this endpoint does not return
IP address information

Example:
    172.25.5.254

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MACAddress
The MAC address tied to the device

Example:
    ae:b1:69:29:55:24

Multiple comma separated values can be inputted

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

### -Type
The type of device

Example:
    SonicWall,Fortinet

Multiple comma separated values can be inputted

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Counters
Flag to include additional firewall counter data

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

### -Page
The target page of data

This is used with pageSize parameter to determine how many
and which items to return

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sort
The sort order for the items queried

Not all values can be sorted

Example:
    AccountId:asc
    AccountId:desc

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
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

[https://celerium.github.io/Celerium.RocketCyber/site/Firewalls/Get-RocketCyberFirewall.html](https://celerium.github.io/Celerium.RocketCyber/site/Firewalls/Get-RocketCyberFirewall.html)

