---
description: 'MagicalGirlWand AI contributor guidance'
---

# MagicalGirlWand – Copilot Instructions

Concise guidance for AI contributions. For complete details, see [AGENTS.md](../AGENTS.md).

## Project Scope

- Treat this repository as standalone CmdPal, not full Microsoft PowerToys.
- Keep user-facing docs Chinese-first when matching the MagicalGirl project family.
- Only list features that exist in this repository.
- Do not restore deleted upstream docs such as `doc/devdocs/`, `doc/specs/`, `doc/dsc/`, or `doc/gpo/README.md`.

## Key Rules

- Make one logical change at a time.
- Add or update tests when changing behavior.
- Keep hot paths quiet.
- Do not commit local-only assistant folders such as `.claude/` or `docs/superpowers/`.
- Keep `tools/cmdpal/standalone-keep-roots.txt` aligned with the actual standalone graph.

## Style Enforcement

- C#: `src/.editorconfig`, StyleCop.Analyzers.
- C++: `src/.clang-format`.
- XAML: XamlStyler or the existing XAML formatting scripts when applicable.

## Common Validation

- Docs-only changes: `git diff --check`.
- Standalone scope changes: `pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1`.
- Build current project or solution: use `tools\build\build.cmd` or `tools\build\build.ps1`.

## Component-Specific Instructions

These are auto-applied based on file location:

- [CmdPal retained settings library](instructions/runner-settings-ui.instructions.md)
- [Common libraries](instructions/common-libraries.instructions.md)

## Main References

- [Project README](../README.md)
- [Contributor guide](../CONTRIBUTING.md)
- [Agent guide](../AGENTS.md)
