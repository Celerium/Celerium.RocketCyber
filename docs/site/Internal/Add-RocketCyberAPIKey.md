---
external help file: Celerium.RocketCyber-help.xml
grand_parent: Internal
Module Name: Celerium.RocketCyber
online version: https://celerium.github.io/Celerium.RocketCyber/site/Internal/Add-RocketCyberAPIKey.html
parent: POST
schema: 2.0.0
title: Add-RocketCyberAPIKey
---

# Add-RocketCyberAPIKey

## SYNOPSIS
Sets your API key used to authenticate all API calls

## SYNTAX

### AsPlainText
```powershell
Add-RocketCyberAPIKey [-ApiKey <String>] [<CommonParameters>]
```

### SecureString
```powershell
Add-RocketCyberAPIKey [-ApiKeySecureString <SecureString>] [<CommonParameters>]
```

## DESCRIPTION
The Add-RocketCyberAPIKey cmdlet sets your API key which is used to
authenticate all API calls made to RocketCyber.
Once the API key is
defined, it is encrypted using SecureString

The RocketCyber API keys are generated via the RocketCyber web interface
at Provider Settings \> RocketCyber API

## EXAMPLES

### EXAMPLE 1
```powershell
Add-RocketCyberAPIKey
```

Prompts to enter in the API key

### EXAMPLE 2
```powershell
Add-RocketCyberAPIKey -ApiKey 'your_ApiKey'
```

The RocketCyber API will use the string entered into the \[ -ApiKey \] parameter

### EXAMPLE 3
```
'12345' | Add-RocketCyberAPIKey
```

The Add-RocketCyberAPIKey function will use the string passed into it as its API key

## PARAMETERS

### -ApiKey
Plain text API key

If not defined the cmdlet will prompt you to enter the API key which
will be stored as a SecureString

```yaml
Type: String
Parameter Sets: AsPlainText
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ApiKeySecureString
Input a SecureString object containing the API key

```yaml
Type: SecureString
Parameter Sets: SecureString
Aliases:

Required: False
Position: Named
Default value: None
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

[https://celerium.github.io/Celerium.RocketCyber/site/Internal/Add-RocketCyberAPIKey.html](https://celerium.github.io/Celerium.RocketCyber/site/Internal/Add-RocketCyberAPIKey.html)

