---
name: release-note-generation
description: Toolkit for generating MagicalGirlWand release notes from GitHub PRs or commit ranges. Use when asked to create release notes, summarize merged changes, prepare changelog copy, update release documentation, or collect changes between tags.
license: Complete terms in LICENSE.txt
---

# Release Note Generation Skill

Generate concise release notes for MagicalGirlWand. Keep the output focused on the standalone CmdPal product surface: CmdPal app, built-in extensions, extension gallery, SDK/Toolkit, templates, build/installer, and documentation.

## Output Directory

Generated artifacts go under `Generated Files/ReleaseNotes/` at the repository root.

```text
Generated Files/ReleaseNotes/
├── collected-prs.json
├── sorted-prs.csv
├── grouped-md/
└── v{VERSION}-release-notes.md
```

## When to Use This Skill

- Generate release notes for a MagicalGirlWand version.
- Summarize PRs merged since a tag or commit.
- Group changes by CmdPal area.
- Prepare changelog copy for a GitHub release.
- Identify docs, build, or installer changes that need callouts.

## Prerequisites

- GitHub CLI (`gh`) installed and authenticated.
- A target version or commit/tag range.
- Repository checkout on the branch being released.

## Required Variables

Confirm `{{ReleaseVersion}}` before writing final notes.

| Variable | Description | Example |
| --- | --- | --- |
| `{{ReleaseVersion}}` | Target MagicalGirlWand release version | `0.11.1` |
| `{{BaseRef}}` | Previous tag or base commit | `v0.11.0` |
| `{{HeadRef}}` | Release head commit or branch | `main` |

## Workflow Overview

1. Read [collection guidance](./references/step1-collection.md).
2. Read [labeling guidance](./references/step2-labeling.md).
3. Read [review and grouping guidance](./references/step3-review-grouping.md).
4. Read [summarization guidance](./references/step4-summarization.md).

Only load the step you are currently executing.

## Grouping Conventions

Use these release-note groups unless the diff clearly needs a new one:

- CmdPal
- Extensions
- Extension SDK
- Gallery
- Build and Installer
- Documentation
- Internal Cleanup

Do not create release-note sections for unrelated PowerToys utilities unless the change is explicitly retained as a dependency cleanup item.

## Available Scripts

| Script | Purpose |
| --- | --- |
| [dump-prs-since-commit.ps1](./scripts/dump-prs-since-commit.ps1) | Fetch PRs between commits/tags |
| [group-prs-by-label.ps1](./scripts/group-prs-by-label.ps1) | Group PRs into CSVs |
| [diff_prs.ps1](./scripts/diff_prs.ps1) | Compare PR lists |

The remaining upstream scripts in this folder are legacy helpers. Do not use Microsoft-internal release asset or milestone automation for MagicalGirlWand unless it is deliberately adapted first.

## Output Style

- Public release copy for this project should be 中文优先.
- Keep human names, account names, human IDs, project names, libraries, and tool names in their original form.
- Mention user-visible changes first.
- Keep internal cleanup concise.
- Include validation notes only when they matter to users or release managers.
- Credit upstream PowerToys only when a change directly imports or syncs upstream work.
