# Changelog

All changes to this module should be reflected in this document.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [[1.3.0]](https://github.com/mod-posh/LocalAutomation/releases/tag/v1.3.0) - 2024-01-05

This release adds support for CSharp Projects

1. CSharpProject
   1. Updated the psake to support C# projects
      1. Added a check for git setup
      2. Added a check for DefaultDocumentation nuget tool
      3. Updated most of the tasks to work with C#
      4. Added BlueSky as a notification option
   2. Updated the nuget.config to work with nuget.org properly

---

## [[1.2.0]](https://github.com/mod-posh/LocalAutomation/releases/tag/v1.2.0) - 2023-06-27

This release updated a few issues with the CsharpModule

1. C-Sharp Module
   1. Fixed README title
   2. Updated README content to suit
   3. Updated Psakefile with a updates
      1. Fixed incorrect taskname
      2. Fixed comment indentation
      3. Added a Source variable for projects that aren't nested within a project folder

---

## [[1.1.0]](https://github.com/mod-posh/LocalAutomation/releases/tag/v1.1.0) - 2023-01-22

This release contains additional documentation and more scripts

1. Vscode
   1. settings.json : How my vscode environment is set up
2. C-Sharp Module
3. Calculate expiration on tokens outside of tasks

---

## [[1.0.0]](https://github.com/mod-posh/LocalAutomation/releases/tag/v1.0.0) - 2023-01-22

The initial release contains the base files as they are from existing repositories with some sanitizing and cleanup.

1. Complex Modules
   1. psakefile       : See the [README](ComplexModules/README.md) for usage instructions
      1. ado.json     : You will need to create a [PAT Token](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows) if you're working with Azure Devops
      2. discord.json : You will need to get a [Webhook Url](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks) if you wish to post to Discord
      3. github.json  : You will need to create a [Github PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
      4. nuget.config : You will need to create a [PowerShell Gallery PAT](https://learn.microsoft.com/en-us/powershell/scripting/gallery/concepts/publishing-guidelines?view=powershell-7.3) to publish to the PowerShell Gallery
2. Simmple Modules
   1. psakefile
      1. ado.json
      2. discord.json
      3. github.json
      4. nuget.config

---
