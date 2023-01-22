# Changelog

All changes to this module should be reflected in this document.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [[1.0.0]](https://github.com/mod-posh/LocalAutomation/releases/tag/v1.0.0) - 2023-01-14

The initial release contains the base files as they are from existing repositories with some sanitizing and cleanup.

1. Complex Modules
   1. psakefile       : See the [README](ComplexModules/README.md) for usage instructions
      1. ado.json     : You will need to create a [PAT Token](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows) if you're working with Azure Devops
      2. discord.json : You will need to get a [Webhook Url](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks) if you wish to post to Discord
      3. github.json  : You will need to create a [Github PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
      4. nuget.config : You will need to create a [PowerShell Gallery PAT](https://learn.microsoft.com/en-us/powershell/scripting/gallery/concepts/publishing-guidelines?view=powershell-7.3) to publish to the PowerShell Gallery

---
