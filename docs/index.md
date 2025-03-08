---
external help file: Celerium.RocketCyber-help.xml
Module Name: Celerium.RocketCyber
online version: https://github.com/Celerium/Celerium.RocketCyber
schema: 2.0.0
title: Home
has_children: true
layout: default
nav_order: 1
---

# RocketCyber API PowerShell Wrapper

<h1 align="center">
  <br>
  <a href="http://Celerium.org"><img src="https://raw.githubusercontent.com/Celerium/Celerium.RocketCyber/main/.github/images/Celerium_PoSHGallery_Celerium.RocketCyber.png" alt="_CeleriumDemo" width="200"></a>
  <br>
  Celerium.RocketCyber
  <br>
</h1>

[![Az_Pipeline][Az_Pipeline-shield]][Az_Pipeline-url]
[![GitHub_Pages][GitHub_Pages-shield]][GitHub_Pages-url]

[![PoshGallery_Version][PoshGallery_Version-shield]][PoshGallery_Version-url]
[![PoshGallery_Platforms][PoshGallery_Platforms-shield]][PoshGallery_Platforms-url]
[![PoshGallery_Downloads][PoshGallery_Downloads-shield]][PoshGallery_Downloads-url]
[![codeSize][codeSize-shield]][codeSize-url]

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]

[![Blog][Website-shield]][Website-url]
[![GitHub_License][GitHub_License-shield]][GitHub_License-url]

---

## Buy me a coffee

Whether you use this project, have learned something from it, or just like it, please consider supporting it by buying me a coffee, so I can dedicate more time on open-source projects like this :)

<a href="https://www.buymeacoffee.com/Celerium" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg" alt="Buy Me A Coffee" style="width:150px;height:50px;"></a>

---

<a name="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://celerium.org">
    <img src="https://raw.githubusercontent.com/Celerium/Celerium.RocketCyber/main/.github/images/Celerium_PoSHGitHub_Celerium.RocketCyber.png" alt="Logo">
  </a>

  <p align="center">
    <a href="https://www.powershellgallery.com/packages/Celerium.RocketCyber" target="_blank">PowerShell Gallery</a>
    ·
    <a href="https://github.com/Celerium/Celerium.RocketCyber/issues/new/choose" target="_blank">Report Bug</a>
    ·
    <a href="https://github.com/Celerium/Celerium.RocketCyber/issues/new/choose" target="_blank">Request Feature</a>
  </p>
</div>

---

## About The Project

The [Celerium.RocketCyber](https://www.powershellgallery.com/packages/Celerium.RocketCyber) offers users the ability to extract data from RocketCyber into third-party reporting tools and aims to abstract away the details of interacting with RocketCyber's API endpoints in such a way that is consistent with PowerShell nomenclature. This gives system administrators and PowerShell developers a convenient and familiar way of using RocketCyber's API to create documentation scripts, automation, and integrations.

- :book: Project documentation can be found on [Github Pages](https://celerium.github.io/Celerium.RocketCyber/)
- :book: RocketCyber's [REST API documentation here](https://api-doc.rocketcyber.com/).

RocketCyber features a REST API that makes use of common HTTPs GET actions. In order to maintain PowerShell best practices, only approved verbs are used.

- GET -> Get-

Additionally, PowerShell's `verb-noun` nomenclature is respected. Each noun is prefixed with `RocketCyber` in an attempt to prevent naming problems.

For example, one might access the `/agent` endpoint by running the following PowerShell command with the appropriate parameters:

```posh
Get-RocketCyberAgent -id e9487ac5443c1b514f8f2c7ca256bb46
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Install

This module can be installed directly from the [PowerShell Gallery](https://www.powershellgallery.com/packages/Celerium.RocketCyber) with the following command:

```posh
Install-Module -Name Celerium.RocketCyber
```

- :information_source: This module supports PowerShell 5.0+ and *should* work in PowerShell Core.
- :information_source: If you are running an older version of PowerShell, or if PowerShellGet is unavailable, you can manually download the *main* branch and place the *Celerium.RocketCyber* folder into the (default) `C:\Program Files\WindowsPowerShell\Modules` folder.

Project documentation can be found on [Github Pages](https://celerium.github.io/Celerium.RocketCyber/)

- A full list of functions can be retrieved by running `Get-Command -Module Celerium.RocketCyber`.
- Help info and a list of parameters can be found by running `Get-Help <command name>`, such as:

```posh
Get-Help Get-RocketCyberAgent
Get-Help Get-RocketCyberAgent -Full
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Initial Setup

After installing this module, you will need to configure both the *base URI* & *API key* that are used to talk with the RocketCyber API.

1. Run `Add-RocketCyberBaseUri`
   - By default, RocketCyber's `https://api-us.rocketcyber.com/v3` URI is used.
   - If you have your own API gateway or proxy, you may put in your own custom URI by specifying the `-BaseUri` parameter:
      - `Add-RocketCyberBaseUri -BaseUri http://myapi.gateway.celerium.org`
<br>

2. Run `Add-RocketCyberApiKey -ApiKey '12345'`
   - It will prompt you to enter your API key if you do not specify it.
   - RocketCyber API keys are generated via the RocketCyber portal under *Provider settings > RocketCyber API*
<br>

3. [**optional**] Run `Export-RocketCyberModuleSettings`
   - This will create a config file at `%UserProfile%\Celerium.RocketCyber` that holds the *base uri* & *API key* information.
   - Next time you run `Import-Module -Name Celerium.RocketCyber`, this configuration file will automatically be loaded.
   - :warning: Exporting module settings encrypts your API keys in a format that can **only be unencrypted by the user principal** that encrypted the secret. It makes use of .NET DPAPI, which for Windows uses reversible encrypted tied to your user principal. This means that you **cannot copy** your configuration file to another computer or user account and expect it to work.
   - :warning: However in Linux\Unix operating systems the secret keys are more obfuscated than encrypted so it is recommend to use a more secure & cross-platform storage method.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Usage

Calling an API resource is as simple as running `Get-RocketCyber<resourceName>`

- The following is a table of supported functions and their corresponding API resources:
- Table entries with [ `-` ] indicate that the functionality is **NOT** supported by the RocketCyber API at this time.

| API Resource       | Create    | Read                              | Update    | Delete    |
| -----------------  | --------- | --------------------------------- | --------- | --------- |
| Account            | -         | `Get-RocketCyberAccount`         | -         | -         |
| Agents             | -         | `Get-RocketCyberAgent`           | -         | -         |
| Apps               | -         | `Get-RocketCyberApp`             | -         | -         |
| Defender           | -         | `Get-RocketCyberDefender`         | -         | -         |
| Events             | -         | `Get-RocketCyberEvent`           | -         | -         |
| EventSummary       | -         | `Get-RocketCyberEvent`           | -         | -         |
| Firewalls          | -         | `Get-RocketCyberFirewall`        | -         | -         |
| Incidents          | -         | `Get-RocketCyberIncident`        | -         | -         |
| Office             | -         | `Get-RocketCyberOffice`           | -         | -         |

Each `Get-RocketCyber*` function will respond with the raw data that RocketCyber's API provides.

- :warning: Returned data is mostly structured the same but does vary between commands.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Contributing

Contributions are what makes the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

See the [CONTRIBUTING](https://github.com/Celerium/Celerium.RocketCyber/blob/main/.github/CONTRIBUTING.md) guide for more information about contributing.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## License

Distributed under the MIT License. See [`LICENSE`](https://github.com/Celerium/Celerium.RocketCyber/blob/main/LICENSE) for more information.

[![GitHub_License][GitHub_License-shield]][GitHub_License-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contact

<div align="left">

  <p align="left">
    ·
    <a href="https://celerium.org/#/contact" target="_blank">Website</a>
    ·
    <a href="mailto: celerium@celerium.org">Email</a>
    ·
    <a href="https://www.reddit.com/user/CeleriumIO" target="_blank">Reddit</a>
    ·
  </p>
</div>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Acknowledgments

Big thank you to the following people and services as they have provided me with lots of helpful information as I continue this project!

- [GitHub Pages](https://pages.github.com)
- [Img Shields](https://shields.io)
- [Font Awesome](https://fontawesome.com)
- [Choose an Open Source License](https://choosealicense.com)
- [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[Az_Pipeline-shield]:               https://img.shields.io/azure-devops/build/AzCelerium/Celerium.RocketCyber/14?style=for-the-badge&label=DevOps_Build
[Az_Pipeline-url]:                  https://dev.azure.com/AzCelerium/Celerium.RocketCyber/_build?definitionId=14

[GitHub_Pages-shield]:              https://img.shields.io/github/actions/workflow/status/celerium/Celerium.RocketCyber/pages%2Fpages-build-deployment?style=for-the-badge&label=GitHub%20Pages
[GitHub_Pages-url]:                 https://github.com/Celerium/Celerium.RocketCyber/actions/workflows/pages/pages-build-deployment

[GitHub_License-shield]:            https://img.shields.io/github/license/celerium/Celerium.RocketCyber?style=for-the-badge
[GitHub_License-url]:               https://github.com/Celerium/Celerium.RocketCyber/blob/main/LICENSE

[PoshGallery_Version-shield]:       https://img.shields.io/powershellgallery/v/Celerium.RocketCyber?include_prereleases&style=for-the-badge
[PoshGallery_Version-url]:          https://www.powershellgallery.com/packages/Celerium.RocketCyber

[PoshGallery_Platforms-shield]:     https://img.shields.io/powershellgallery/p/Celerium.RocketCyber?style=for-the-badge
[PoshGallery_Platforms-url]:        https://www.powershellgallery.com/packages/Celerium.RocketCyber

[PoshGallery_Downloads-shield]:     https://img.shields.io/powershellgallery/dt/Celerium.RocketCyber?style=for-the-badge
[PoshGallery_Downloads-url]:        https://www.powershellgallery.com/packages/Celerium.RocketCyber

[website-shield]:                   https://img.shields.io/website?up_color=blue&url=https%3A%2F%2Fcelerium.org&style=for-the-badge&label=Blog
[website-url]:                      https://celerium.org

[codeSize-shield]:                  https://img.shields.io/github/repo-size/celerium/Celerium.RocketCyber?style=for-the-badge
[codeSize-url]:                     https://github.com/Celerium/Celerium.RocketCyber

[contributors-shield]:              https://img.shields.io/github/contributors/celerium/Celerium.RocketCyber?style=for-the-badge
[contributors-url]:                 https://github.com/Celerium/Celerium.RocketCyber/graphs/contributors

[forks-shield]:                     https://img.shields.io/github/forks/celerium/Celerium.RocketCyber?style=for-the-badge
[forks-url]:                        https://github.com/Celerium/Celerium.RocketCyber/network/members

[stars-shield]:                     https://img.shields.io/github/stars/celerium/Celerium.RocketCyber?style=for-the-badge
[stars-url]:                        https://github.com/Celerium/Celerium.RocketCyber/stargazers

[issues-shield]:                    https://img.shields.io/github/issues/Celerium/Celerium.RocketCyber?style=for-the-badge
[issues-url]:                       https://github.com/Celerium/Celerium.RocketCyber/issues
