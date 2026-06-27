---
description: PowerShell scripts for efficient PR reviews in the MagicalGirlWand repository
applyTo: '**'
---

# PR Review Tools - Reference Guide

PowerShell scripts under `.github/review-tools/` support efficient and incremental pull request reviews for MagicalGirlWand.

## Prerequisites

- PowerShell 7+ or Windows PowerShell 5.1+
- GitHub CLI (`gh`) installed and authenticated
- Access to the `LingMoe404/MagicalGirlWand` repository

## Available Scripts

### Get-GitHubRawFile.ps1

Downloads file content from a GitHub repository at a specific ref.

Common usage:

```powershell
.\Get-GitHubRawFile.ps1 -FilePath "README.md" -GitReference "main"
```

Default repository parameters should target this repository when used for MagicalGirlWand reviews:

```powershell
-RepositoryOwner "LingMoe404" -RepositoryName "MagicalGirlWand"
```

### Get-GitHubPrFilePatch.ps1

Fetches the unified diff for a file in a pull request.

```powershell
.\Get-GitHubPrFilePatch.ps1 -PullRequestNumber 123 -FilePath "src/modules/cmdpal/README.md" -RepositoryOwner "LingMoe404" -RepositoryName "MagicalGirlWand"
```

### Get-PrIncrementalChanges.ps1

Compares the last reviewed commit with the current PR head.

```powershell
.\Get-PrIncrementalChanges.ps1 -PullRequestNumber 123 -LastReviewedCommitSha "abc123" -RepositoryOwner "LingMoe404" -RepositoryName "MagicalGirlWand"
```

### Test-IncrementalReview.ps1

Previews incremental review detection before running the full review prompt.

```powershell
.\Test-IncrementalReview.ps1 -PullRequestNumber 123 -RepositoryOwner "LingMoe404" -RepositoryName "MagicalGirlWand"
```

## Review Scope

Review comments should be grounded in the current MagicalGirlWand scope:

- CmdPal app, UI, settings, gallery, and branding.
- Built-in CmdPal extensions.
- Extension SDK, Toolkit, and template.
- Build, installer, and standalone validation.
- Documentation and AI guidance files.
- Retained upstream dependencies only when the PR changes them.

Do not require contributors to update deleted PowerToys docs or unrelated Microsoft release infrastructure.

## Integration

These scripts are referenced by `.github/prompts/review-pr.prompt.md`. Generated review artifacts belong under:

```text
Generated Files/prReview/<PR_NUMBER>/
```

`Generated Files/` is local review output and should not be committed unless the maintainer explicitly asks for it.

## Troubleshooting

- If `gh` is missing, install GitHub CLI and run `gh auth login`.
- If a PR cannot be found, verify the repository owner/name parameters.
- If a force-push invalidates the last reviewed SHA, run a full review.
- If generated review files are stale, delete the specific `Generated Files/prReview/<PR_NUMBER>/` folder and rerun the review.

For repository contribution rules, see [AGENTS.md](../../AGENTS.md) and [CONTRIBUTING.md](../../CONTRIBUTING.md).
