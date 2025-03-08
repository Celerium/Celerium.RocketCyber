---
title: Tracking CSV
parent: Home
nav_order: 2
---

# Tracking CSV

When updating the documentation for this project, the tracking CSV plays a huge part in organizing of the markdown documents. Any new functions or endpoints should be added to the tracking CSV when publishing an updated module or documentation version.

{: .warning }
I recommend downloading the CSV from the link provided rather then viewing the table below.

[Tracking CSV](https://github.com/Celerium/Celerium.RocketCyber/blob/main/docs/Endpoints.csv)

---

## CSV markdown table

|Category |EndpointUri    |Method|Function                        |Complete|Notes|
|---------|---------------|------|--------------------------------|--------|-----|
|Account  |/account       |GET   |Get-RocketCyberAccount          |YES     |     |
|Agents   |/agents        |GET   |Get-RocketCyberAgent            |YES     |     |
|Apps     |/apps          |GET   |Get-RocketCyberApp              |YES     |     |
|Defender |/defender      |GET   |Get-RocketCyberDefender         |YES     |     |
|Events   |/events        |GET   |Get-RocketCyberEvent            |YES     |     |
|Events   |/events/summary|GET   |Get-RocketCyberEvent            |YES     |     |
|Firewalls|/firewalls     |GET   |Get-RocketCyberFirewall         |YES     |     |
|Incidents|/incidents     |GET   |Get-RocketCyberIncident         |YES     |     |
|Internal |               |DELETE|Remove-RocketCyberAPIKey        |YES     |     |
|Internal |               |DELETE|Remove-RocketCyberBaseUri       |YES     |     |
|Internal |               |DELETE|Remove-RocketCyberModuleSettings|YES     |     |
|Internal |               |GET   |Invoke-RocketCyberRequest       |YES     |     |
|Internal |               |GET   |Get-RocketCyberAPIKey           |YES     |     |
|Internal |               |GET   |Test-RocketCyberAPIKey          |YES     |     |
|Internal |               |GET   |Get-RocketCyberBaseUri          |YES     |     |
|Internal |               |GET   |Export-RocketCyberModuleSettings|YES     |     |
|Internal |               |GET   |Get-RocketCyberModuleSettings   |YES     |     |
|Internal |               |GET   |Import-RocketCyberModuleSettings|YES     |     |
|Internal |               |POST  |Add-RocketCyberAPIKey           |YES     |     |
|Internal |               |POST  |Add-RocketCyberBaseUri          |YES     |     |
|Internal |               |PUT   |ConvertTo-RocketCyberQueryString|YES     |     |
|Office   |/office        |GET   |Get-RocketCyberOffice           |YES     |     |

