function Update-HelpContent {
<#
.NOTES
    Copyright 1990-2024 Celerium

    NAME: Update-HelpContent.ps1
    Type: PowerShell

        AUTHOR:  David Schulte
        DATE:    2022-11-26
        EMAIL:   celerium@celerium.org
        Updated: 2023-09-16

    TODO:
    Find a better way to make\update the main module file, as of 2022-11 this script double generates markdown files
    When run with PowerShell 7, examples with comma separated values turn into line breaks
    See about cross platform cab file generation

.SYNOPSIS
    Updates or creates markdown help files

.DESCRIPTION
    The Update-HelpContent script updates or creates markdown help files which are
    used by both Github pages and as external help.

    The markdown documents created contain metadata that GitHub pages directly use
    to build its entire documentation structure\site.

    This also generates external XML\cab help files.
        - 2022-11: More research is needed to fully implement external help

.PARAMETER ModuleName
    The name of the module to generate help documents for

    Example: Celerium.RocketCyber

.PARAMETER HelpDocsPath
    Location to store the markdown help docs

    All markdown help docs should be located outside the module folder.
    Reference:
        Yes - "Celerium.RocketCyber\docs"
        NO  - "Celerium.RocketCyber\Celerium.RocketCyber\docs"

    Example: "C:\Celerium\Projects\Celerium.RocketCyber\docs"

.PARAMETER CsvFilePath
    Location where the tracking CSV is located including the CSV file name

    The tracking CSV should be located in "Celerium.RocketCyber\docs"
    Reference:
        Yes - "Celerium.RocketCyber\docs\Endpoints.csv"
        NO  - "Celerium.RocketCyber\Celerium.RocketCyber\docs\Endpoints.csv"

    Example: "C:\Celerium\Projects\Celerium.RocketCyber\docs\Endpoints.csv"

.PARAMETER GithubPageUri
    Base url of the modules github pages

    Example: "https://celerium.github.io/Celerium.RocketCyber"

.PARAMETER ShowHelpDocs
    Opens the directory with the HelpDocs when completed

.EXAMPLE
    .\Update-HelpContent.ps1
        -ModuleName Celerium.RocketCyber
        -HelpDocsPath "C:\Celerium\Projects\Celerium.RocketCyber\docs"
        -CsvFilePath "C:\Celerium\Projects\Celerium.RocketCyber\docs\Endpoints.csv"
        -GithubPageUri "https://celerium.github.io/Celerium.RocketCyber"

    Updates markdown docs and external help files

    No progress information is sent to the console while the script is running.

.EXAMPLE
    .\Update-HelpContent.ps1
        -ModuleName Celerium.RocketCyber
        -HelpDocsPath "C:\Celerium\Projects\Celerium.RocketCyber\docs"
        -CsvFilePath "C:\Celerium\Projects\Celerium.RocketCyber\docs\Endpoints.csv"
        -GithubPageUri "https://celerium.github.io/Celerium.RocketCyber"
        -verbose

    Updates markdown docs and external help files

    Progress information is sent to the console while the script is running.

.INPUTS
    N\A

.OUTPUTS
    N\A

.LINK
    https://celerium.org

#>

#Region  [ Parameters ]

[CmdletBinding()]
param(
        [Parameter(Mandatory=$true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$ModuleName,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$HelpDocsPath,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$CsvFilePath,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$GithubPageUri,

        [Parameter(Mandatory=$false)]
        [Switch]$ShowHelpDocs
    )

#EndRegion  [ Parameters ]

Write-Verbose ''
Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''

Write-Verbose " - (1/3) - $(Get-Date -Format MM-dd-HH:mm) - Configuring prerequisites"

#Region     [ Prerequisites ]

$startDate = Get-Date

#trim trailing slashes from urls
if ($HelpDocsPath[$HelpDocsPath.Length-1] -eq "/" -or $HelpDocsPath[$HelpDocsPath.Length-1] -eq "\") {
    $HelpDocsPath = $HelpDocsPath.Substring(0,$HelpDocsPath.Length-1)
}
if ($GithubPageUri[$GithubPageUri.Length-1] -eq "/" -or $GithubPageUri[$GithubPageUri.Length-1] -eq "\") {
    $GithubPageUri = $GithubPageUri.Substring(0,$GithubPageUri.Length-1)
}

$ModulePage         = Join-Path -Path $HelpDocsPath -ChildPath "$ModuleName.md"
$TempFolder         = Join-Path -Path $HelpDocsPath -ChildPath "temp"
$SiteStructureFolder= Join-Path -Path $HelpDocsPath -ChildPath "site"
$ExternalHelp       = Join-Path -Path $HelpDocsPath -ChildPath "en-US"
$ExternalHelpCab    = Join-Path -Path $HelpDocsPath -ChildPath "cab"

$DocFolders = $HelpDocsPath,$TempFolder,$SiteStructureFolder,$ExternalHelp,$ExternalHelpCab

$TemplatePages = 'DELETE.md', 'GET.md', 'Index.md', 'POST.md', 'PUT.md'

Try{

    if (Get-InstalledModule -Name platyPS -ErrorAction SilentlyContinue -Verbose:$false 4>$null) {
        Import-Module -Name platyPS -Verbose:$false
    }
    else{
        throw "The platyPS module was not found"
    }

    if ($IsWindows -or $PSEdition -eq 'Desktop') {
        $RootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\build', [System.StringComparison]::OrdinalIgnoreCase)) )"
    }
    else{
        $RootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('/build', [System.StringComparison]::OrdinalIgnoreCase)) )"
    }

    $ModulePath = Join-Path -Path $RootPath -ChildPath $ModuleName
    $ModulePsd1 = Join-Path -Path $ModulePath -ChildPath "$ModuleName.psd1"

        if (Test-Path -Path $ModulePsd1 ) {
            Import-Module -Name $ModulePsd1 -Force -Verbose:$false
            $Commands = Get-Command -Module $ModuleName -ErrorAction Stop | Where-Object {$_.CommandType -eq 'Function'} | Sort-Object Name
        }
        else{
            throw "The [ $ModuleName ] module was not found"
        }

    ForEach ($Folder in $DocFolders) {

        if ( ($Folder -ne $HelpDocsPath) -and (Test-Path -Path $Folder -PathType Container) ) {
            Remove-Item -Path $Folder -Force -Recurse
            New-Item -Path $Folder -ItemType Directory > $null
        }
        else{
            if ( (Test-Path -Path $Folder -PathType Container) -eq $false ) {
                New-Item -Path $Folder -ItemType Directory > $null
            }
        }

    }

    if ( (Test-Path -Path $CsvFilePath -PathType Leaf) -eq $false ) {
        throw "The required CSV file was not found at [ $CsvFilePath ]"
    }
    else{
        $CSV = Import-Csv -Path $CsvFilePath
    }

}
Catch{
    Write-Error $_
    exit 1
}

#EndRegion     [ Prerequisites ]

Write-Verbose " - (2/4) - $(Get-Date -Format MM-dd-HH:mm) - Regenerating module document"

#Region     [ Base module help ]

New-MarkdownHelp -Module $ModuleName -WithModulePage -ModulePagePath $ModulePage -OutputFolder $TempFolder -Force > $null

    Update-MarkdownHelpModule -Path $TempFolder -RefreshModulePage -ModulePagePath $ModulePage > $null

    Remove-Item -Path $TempFolder -Recurse -Force > $null

Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Updating module metadata"

#will change when external help is figured out
$downloadLink = "$GithubPageUri/docs/cab"

    #Add GitHub pages parent
    $content = Get-Content -Path $ModulePage
    $newContent = $content -replace "Module Name", "parent: Home `nModule Name"
    $newContent | Set-Content -Path $ModulePage

    #Adjust module download links
    $content = Get-Content -Path $ModulePage
    $newContent = $content -replace "(?<=Download Help Link:).*", " $DownloadLink"
    $newContent | Set-Content -Path $ModulePage

    #Adjust module description
    $moduleDescription = 'This PowerShell module acts as a wrapper for the RocketCyber API.'

    $content = Get-Content -Path $ModulePage -Raw
    [regex]$updateDescription = "{{ Fill in the Description }}"
    $newContent = $updateDescription.replace($content, "$moduleDescription", 1)
    $newContent | Set-Content -Path $ModulePage -NoNewline

#EndRegion  [ Base module help ]

Write-Verbose " - (3/4) - $(Get-Date -Format MM-dd-HH:mm) - Regenerating [ $( ($Commands | Measure-Object).count) ] help documents"

#Region     [ Organize Markdown ]

ForEach ( $Cmdlet in $Commands ) {

    #Helps avoid files in use by another process error
    Start-Sleep -Milliseconds 250

    $CsvData = $CSV | Where-Object {$_.Function -like "*$($Cmdlet.Name)"}

    $Category = $($CsvData.Category | Select-Object -Unique)
        if ($null -eq $Category) {
            $Category = '_Unique'
        }

    $Method = $($CsvData.Method | Select-Object -Unique)
        if ($null -eq $Method) {
            $Method = 'Special'
            Write-Warning " -       - $(Get-Date -Format MM-dd-HH:mm) - Unique command found, manually adjust the CSV file & metadata for [ $($Cmdlet.Name) ]"
        }

    $CategoryPath = Join-Path -Path $SiteStructureFolder -ChildPath $Category
        if ( (Test-Path -Path $CategoryPath -PathType Container) -eq $false ) {
            New-Item -Path $CategoryPath -ItemType Directory > $null
        }

    $onlineVersion = "$GithubPageUri/site/$Category/$($Cmdlet.Name).html"
    $newMetadata = @{
        'title' = $($Cmdlet.Name)
        'parent' = $Method
        'grand_parent' = $Category
    }
    New-MarkdownHelp -Command $Cmdlet -Metadata $newMetadata -OnlineVersionUrl $onlineVersion -OutputFolder $CategoryPath -Force > $null

    #Adjust module uri links
    $content = Get-Content -Path $ModulePage
    $newContent = $content -replace "$($Cmdlet.Name + '.md')","site/$Category/$($Cmdlet.Name + '.md')"
    $newContent | Set-Content -Path $ModulePage

    #Adjust module powershell code fence
    $content = Get-Content -Path $( Join-Path -Path $CategoryPath -ChildPath "$($Cmdlet.Name + '.md')" ) -Raw
    $newContent = $content -replace '(?m)(?<fence>^```)(?=\r\n\w+)', "`${fence}powershell"
    $newContent | Set-Content -Path $( Join-Path -Path $CategoryPath -ChildPath "$($Cmdlet.Name + '.md')" ) -NoNewline

#Region     [ Template Code ]

    ForEach ($Template in $TemplatePages) {

        $template_Path = $(Join-Path -Path $CategoryPath -ChildPath $Template)

        if ($Template -ne 'Index.md') {
            $fileContents = @"
---
title: $( ($Template -replace '.md','').ToUpper())
parent: xxparentxx
has_children: true
---
"@
        }
        else{ $fileContents = @"
---
title: xxparentxx
has_children: true
---

## xxparentxx - endpoint help & documentation

{: .highlight }
Some functions will handle more than one endpoint and the numbers below show the total endpoints **not** the total functions

| **Method** | **Endpoint Count**  |
|------------|---------------------|
| DELETE     | xdeleteCountx       |
| GET        | xgetCountx          |
| POST       | xpostCountx         |
| PUT        | xputCountx          |

Have a look around and if you would like to contribute please read over the [Contributing guide](https://github.com/Celerium/Celerium.RocketCyber/blob/main/.github/CONTRIBUTING.md)
"@
        }

        if( $Template -eq 'Index.md' ) {
            New-Item -Path $template_Path -ItemType File -Value $fileContents -Force > $null
        }
        else{
            New-Item -Path $( Join-Path -Path $CategoryPath -ChildPath $(($Template -replace '.md','').ToUpper() + '.md') ) -ItemType File -Value $fileContents -Force > $null
        }

        #Title and Parents
        $content = Get-Content -Path $template_Path
        $newContent = $content -replace 'xxparentxx',"$Category"
        $newContent | Set-Content -Path $template_Path

        if( $Template -eq 'Index.md' ) {

            $Counts = 'xdeleteCountx', 'xgetCountx', 'xpostCountx', 'xputCountx'
            ForEach ($Count in $Counts) {

                $content = Get-Content -Path $template_Path

                Switch($Count) {
                    'xdeleteCountx' { $countValue = ($CSV | Where-Object {$_.Method -eq 'Delete' -and $_.Category -eq $Category} | Measure-Object).count }
                    'xgetCountx'    { $countValue = ($CSV | Where-Object {$_.Method -eq 'Get' -and $_.Category -eq $Category} | Measure-Object).count }
                    'xpostCountx'   { $countValue = ($CSV | Where-Object {$_.Method -eq 'Post' -and $_.Category -eq $Category} | Measure-Object).count }
                    'xputCountx'    { $countValue = ($CSV | Where-Object {$_.Method -eq 'Put' -and $_.Category -eq $Category} | Measure-Object).count }
                }

                $newContent = $content -replace $Count,$countValue
                $newContent | Set-Content -Path $template_Path

            }
        }

    }

#EndRegion  [ Template Code ]

}

#EndRegion  [ Organize Markdown ]

Write-Verbose " - (4/4) - $(Get-Date -Format MM-dd-HH:mm) - Regenerating external help"

#Region     [ External Help ]

if ($IsWindows -or $PSEdition -eq 'Desktop') {

    $helpFilePaths = [System.Collections.Generic.List[object]]::new()
    $helpFiles = (Get-ChildItem -Path $SiteStructureFolder -Include "*.md" -Exclude index*,delete*,post*,put*,get.* -Recurse | Sort-Object fullName).fullName

        ForEach ($File in $helpFiles) {
            $helpFilePaths.Add($File) > $null
        }

    New-ExternalHelp -Path $helpFilePaths -OutputPath $ExternalHelp -Force > $null


    New-ExternalHelpCab -CabFilesFolder $ExternalHelp -LandingPagePath $ModulePage -OutputFolder $ExternalHelpCab -IncrementHelpVersion > $null

}
else{
    Write-Warning " -       - $(Get-Date -Format MM-dd-HH:mm) - [ New-ExternalHelpCab ] MakeCab.exe requirement is not compatible at this time"
}

#EndRegion  [ External Help ]

if (Get-Module -Name $ModuleName) {
    Remove-Module -Name $ModuleName -Force -Verbose:$false
}

#Open File Explorer to show doc output
if ($ShowHelpDocs) {
    Invoke-Item $HelpDocsPath
}

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''

$TimeToComplete = New-TimeSpan -Start $startDate -End (Get-Date)
Write-Verbose 'Time to complete'
Write-Verbose ($TimeToComplete | Select-Object * -ExcludeProperty Ticks,Total*,Milli* | Out-String)

}