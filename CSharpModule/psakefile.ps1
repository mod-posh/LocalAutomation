$script:ModuleName = '';                                                                 # The name of your PowerShell module
$script:GithubOrg = ''                                                                   # This could be your github username if you're not working in a Github Org
$script:Repository = "https://github.com/$($script:GithubOrg)";                          # This is the Github Repo
$script:DeployBranch = 'master';                                                         # The branch that we deploy from, typically master or main
$script:Source = Join-Path $PSScriptRoot $script:ModuleName;                                    # This will be the root of your Module Project, not the Repository Root
$script:Output = Join-Path $PSScriptRoot 'output';                                       # The module will be output into this folder
$script:Docs = Join-Path $PSScriptRoot 'docs';                                           # The root folder for the PowerShell Module
$script:Destination = Join-Path $Output $script:ModuleName;                                     # The PowerShell module folder that contains the manifest and other files
$script:ModulePath = "$Destination\$script:ModuleName.psm1";                                    # The main PowerShell Module file
$script:ManifestPath = "$Destination\$script:ModuleName.psd1";                                  # The main PowerShell Module Manifest
$script:TestFile = ("TestResults_$(Get-Date -Format s).xml").Replace(':', '-');          # The Pester Test output file
$script:PoshGallery = "https://www.powershellgallery.com/packages/$($script:ModuleName)" # The PowerShell Gallery URL

$BuildHelpers = Get-Module -ListAvailable | Where-Object -Property Name -eq BuildHelpers;
if ($BuildHelpers)
{
 Write-Host -ForegroundColor Blue "Info: BuildHelpers Version $($BuildHelpers.Version) Found";
 Write-Host -ForegroundColor Blue "Info: This automation built with BuildHelpers Version 2.0.16";
 Import-Module BuildHelpers;
}
else
{
 throw "Please Install-Module -Name BuildHelpers";
}
$PowerShellForGitHub = Get-Module -ListAvailable | Where-Object -Property Name -eq PowerShellForGitHub;
if ($PowerShellForGitHub)
{
 Write-Host -ForegroundColor Blue "Info: PowerShellForGitHub Version $($PowerShellForGitHub.Version) Found";
 Write-Host -ForegroundColor Blue "Info: This automation built with PowerShellForGitHub Version 0.16.1";
 Import-Module PowerShellForGitHub;
}
else
{
 throw "Please Install-Module -Name PowerShellForGitHub";
}
$PlatyPS = Get-Module -ListAvailable | Where-Object -Property Name -eq PlatyPS;
if ($PlatyPS)
{
 Write-Host -ForegroundColor Blue "Info: PowerShellForGitHub Version $($PlatyPS.Version) Found";
 Write-Host -ForegroundColor Blue "Info: This automation built with PowerShellForGitHub Version 0.14.2";
 Import-Module PlatyPS;
}
else
{
 throw "Please Install-Module -Name PlatyPS";
}
$Pester = Get-Module -ListAvailable | Where-Object -Property Name -eq Pester;
if ($Pester)
{
 Write-Host -ForegroundColor Blue "Info: PowerShellForGitHub Version $($Pester.Version) Found";
 Write-Host -ForegroundColor Blue "Info: This automation built with PowerShellForGitHub Version 3.4.0";
 Import-Module Pester;
}
else
{
 throw "Please Install-Module -Name Pester";
}

Write-Host -ForegroundColor Green "ModuleName   : $($script:ModuleName)";
Write-Host -ForegroundColor Green "Githuborg    : $($script:Source)";
Write-Host -ForegroundColor Green "Source       : $($script:Source)";
Write-Host -ForegroundColor Green "Output       : $($script:Output)";
Write-Host -ForegroundColor Green "Docs         : $($script:Docs)";
Write-Host -ForegroundColor Green "Destination  : $($script:Destination)";
Write-Host -ForegroundColor Green "ModulePath   : $($script:ModulePath)";
Write-Host -ForegroundColor Green "ManifestPath : $($script:ManifestPath)";
Write-Host -ForegroundColor Green "TestFile     : $($script:TestFile)";
Write-Host -ForegroundColor Green "Repository   : $($script:Repository)";
Write-Host -ForegroundColor Green "PoshGallery  : $($script:PoshGallery)";
Write-Host -ForegroundColor Green "DeployBranch : $($script:DeployBranch)";

Task default -depends UpdateReadme

Task Clean {
 $null = Remove-Item $Output -Recurse -ErrorAction Ignore
 $null = New-Item -Type Directory -Path $Destination
}

Task LocalUse -Description "Setup for local use and testing" -depends CreateModuleDirectory, CleanModuleDirectory, CleanProject, BuildProject, CopyModuleFiles, PesterTest -Action {
 $Global:settings = Get-Content .\ConnectionSettings
}

Task UpdateHelp -Description "Update the help files" -depends CreateModuleDirectory, CleanProject, BuildProject, CopyModuleFiles, PesterTest -Action {
 $script:ModuleName = 'PoshMongo'
 Import-Module -Name ".\Module\$($script:ModuleName).psd1" -Scope Global -force;
 New-MarkdownHelp -Module PoshMongo -AlphabeticParamsOrder -UseFullTypeName -WithModulePage -OutputFolder .\Docs\ -ErrorAction SilentlyContinue
 Update-MarkdownHelp -Path .\Docs\ -AlphabeticParamsOrder -UseFullTypeName
}

Task UpdateReadme -Description "Update the README file" -depends CreateModuleDirectory, CleanProject, BuildProject, CopyModuleFiles, PesterTest -Action {
 $script:ModuleName = 'PoshMongo'
 $readMe = Get-Item .\README.md

 $TableHeaders = "| Latest Version | PowerShell Gallery | Issues | License | Discord |"
 $Columns = "|-----------------|----------------|----------------|----------------|----------------|"
 $VersionBadge = "[![Latest Version](https://img.shields.io/github/v/tag/PoshMongo/PoshMongo)](https://github.com/PoshMongo/PoshMongo/tags)"
 $GalleryBadge = "[![Powershell Gallery](https://img.shields.io/powershellgallery/dt/PoshMongo)](https://www.powershellgallery.com/packages/PoshMongo)"
 $IssueBadge = "[![GitHub issues](https://img.shields.io/github/issues/PoshMongo/PoshMongo)](https://github.com/PoshMongo/PoshMongo/issues)"
 $LicenseBadge = "[![GitHub license](https://img.shields.io/github/license/PoshMongo/PoshMongo)](https://github.com/PoshMongo/PoshMongo/blob/master/LICENSE)"
 $DiscordBadge = "[![Discord Server](https://assets-global.website-files.com/6257adef93867e50d84d30e2/636e0b5493894cf60b300587_full_logo_white_RGB.svg)]($($DiscordChannel))"

 if (!(Get-Module -Name $script:ModuleName )) { Import-Module -Name ".\Module\$($script:ModuleName).psd1" }

 Write-Output $TableHeaders | Out-File $readMe.FullName -Force
 Write-Output $Columns | Out-File $readMe.FullName -Append
 Write-Output "| $($VersionBadge) | $($GalleryBadge) | $($IssueBadge) | $($LicenseBadge) | $($DiscordBadge) |" | Out-File $readMe.FullName -Append

 Get-Content .\Docs\PoshMongo.md | Select-Object -Skip 8 | ForEach-Object { $_.Replace('(', '(Docs/') } | Out-File $readMe.FullName -Append
 Write-Output "" | Out-File $readMe.FullName -Append
 Get-Content .\Build.md | Out-File $readMe.FullName -Append
}

Task SetupModule -Description "Setup the PowerShell Module" -depends CreateModuleDirectory, CleanModuleDirectory, CleanProject, BuildProject, CopyModuleFiles, PesterTest, CreateExternalHelp, CreateCabFile, CreateNuSpec, NugetPack, NugetPush

Task NewTaggedRelease -Description "Create a tagged release" -depends CreateModuleDirectory, CleanProject, BuildProject, CopyModuleFiles, PesterTest -Action {
 $script:ModuleName = 'PoshMongo'

 if (!(Get-Module -Name $script:ModuleName )) { Import-Module -Name ".\Module\$($script:ModuleName).psd1" }
 $Version = (Get-Module -Name $script:ModuleName | Select-Object -Property Version).Version.ToString()
 git tag -a v$version -m "$($script:ModuleName) Version $($Version)"
 git push origin v$version
}

Task Post2Discord -Description "Post a message to discord" -Action {
 $version = (Get-Module -Name $($script:ModuleName) | Select-Object -Property Version).Version.ToString()
 $Discord = Get-Content -Path "$($PSScriptRoot)\discord.json" | ConvertFrom-Json
 $Discord.message.content = "Version $($version) of $($script:ModuleName) released. Please visit Github ($($script:Repository)/$($script:ModuleName)) or PowershellGallery ($($script:PoshGallery)) to download."
 Invoke-RestMethod -Uri $Discord.uri -Body ($Discord.message | ConvertTo-Json -Compress) -Method Post -ContentType 'application/json; charset=UTF-8'
}

Task CleanProject -Description "Clean the project before building" -Action {
 dotnet clean .\PoshMongo\PoshMongo.csproj
}

Task BuildProject -Description "Build the project" -Action {
 dotnet build .\PoshMongo\PoshMongo.csproj -c Release
}

Task CreateModuleDirectory -Description "Create the module directory" -Action {
 New-Item Module -ItemType Directory -Force
}

Task CleanModuleDirectory -Description "Clean the module directory" -Action {
 Get-ChildItem .\Module\ | Remove-Item
}

Task CopyModuleFiles -Description "Copy files for the module" -Action {
 Copy-Item .\PoshMongo\bin\Release\net6.0\*.dll Module -Force
 Copy-Item .\PoshMongo.psd1 Module -Force
}

Task CreateExternalHelp -Description "Create external help file" -Action {
 New-ExternalHelp -Path .\Docs -OutputPath .\Module\ -Force
}

Task CreateCabFile -Description "Create cab file for download" -Action {
 New-ExternalHelpCab -CabFilesFolder .\Module\ -LandingPagePath .\Docs\PoshMongo.md -OutputFolder .\cabs\
}

Task CreateNuSpec -Description "Create NuSpec file for upload" -Action {
 .\ConvertTo-NuSpec.ps1 -ManifestPath ".\Module\PoshMongo.psd1"
}

Task NugetPack -Description "Pack the nuget file" -Action {
 nuget pack .\Module\PoshMongo.nuspec -OutputDirectory .\Module
}

Task NugetPush -Description "Push nuget to PowerShell Gallery" -Action {
 $config = [xml](Get-Content .\nuget.config)
 nuget push .\Module\*.nupkg -NonInteractive -ApiKey "$($config.configuration.apikeys.add.value)" -ConfigFile .\nuget.config
}

Task PesterTest -Description "Test Cmdlets" -Action {
 Invoke-Pester
}