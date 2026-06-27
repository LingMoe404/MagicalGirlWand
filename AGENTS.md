---
description: 'Top-level AI contributor guidance for MagicalGirlWand, a standalone CmdPal-focused Windows project'
applyTo: '**'
---

# MagicalGirlWand – AI Contributor Guide

MagicalGirlWand is a standalone fork focused on Microsoft PowerToys CmdPal. Treat this repository as a CmdPal-centered Windows app, not as the full PowerToys product suite.

Keep changes atomic, follow the existing C# / C++ / WinUI patterns, and cite exact paths when summarizing work.

## Project Scope

The active product surface is CmdPal and the pieces needed to build, run, test, package, or extend it.

| Area | Location | Description |
|------|----------|-------------|
| CmdPal app | `src/modules/cmdpal/Microsoft.CmdPal.UI/` | WinUI app, shell, settings, gallery, branding, and user-facing CmdPal experience |
| CmdPal view models | `src/modules/cmdpal/Microsoft.CmdPal.UI.ViewModels/` | App state, commands, extension gallery, settings, and service wiring |
| Extension interface | `src/modules/cmdpal/extensionsdk/Microsoft.CommandPalette.Extensions/` | Native extension ABI and WinRT contracts |
| Extension toolkit | `src/modules/cmdpal/extensionsdk/Microsoft.CommandPalette.Extensions.Toolkit/` | C# helper layer for extension authors |
| Built-in extensions | `src/modules/cmdpal/ext/` | Apps, Shell, System, Web Search, Windows Settings, Windows Terminal, Clipboard History, Window Walker, and related CmdPal extensions |
| Extension template | `src/modules/cmdpal/ExtensionTemplate/` | Template used by the `Create extension` flow |
| CmdPal tests | `src/modules/cmdpal/Tests/` | Unit and UI tests for CmdPal, extensions, and toolkit behavior |
| Shared dependencies | `src/common/`, `src/settings-ui/Settings.UI.Library/` | Shared code still required by the standalone CmdPal graph |
| Build scripts | `tools/build/` | Build wrappers and MSBuild environment setup |
| Standalone checks | `tools/cmdpal/` | CmdPal dependency closure and standalone validation scripts |

Do not describe or expand unrelated PowerToys utilities as product features of this repository. If upstream-only modules remain as build dependencies, treat them as implementation dependencies unless the user explicitly asks to work on them.

## Current Product Facts

- Product name: `MagicalGirlWand`
- Version source: `src/modules/cmdpal/custom.props`
- Default CmdPal shortcut in code: `Alt+Space`
- Main solution: `MagicalGirlWand.slnx`
- Root README style should follow the sibling MagicalGirl project family when available: Chinese-first, project-specific, and only listing real current features.

## Documentation Boundaries

Keep repository documentation focused on the standalone CmdPal project.

- Do not reintroduce deleted PowerToys developer documentation such as `doc/devdocs/`, `doc/specs/`, `doc/dsc/`, or `doc/gpo/README.md`.
- Do not add README links to documents that do not exist.
- Do not advertise PowerToys modules that are not part of the MagicalGirlWand product surface.
- `docs/superpowers/` is local-only and must remain untracked.
- `.claude/` is local-only and must remain untracked.
- If a retained upstream file contains stale PowerToys wording, either update it for MagicalGirlWand or leave it untouched unless it affects the current task.

## Build

### Prerequisites

- Visual Studio 2022 17.4+ or Visual Studio 2026
- Windows 10 / Windows 11
- Submodules initialized once:

```powershell
git submodule update --init --recursive
```

### Common Commands

| Task | Command |
|------|---------|
| First build / NuGet restore | `tools\build\build-essentials.cmd` |
| Build current solution or project folder | `tools\build\build.cmd` |
| Build Debug x64 | `tools\build\build.ps1 -Platform x64 -Configuration Debug` |
| Build Release x64 | `tools\build\build.ps1 -Platform x64 -Configuration Release` |
| Validate standalone CmdPal graph | `pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1` |

### Build Discipline

1. Build before running tests or launching the app.
2. Use the scripts in `tools/build/` unless there is a strong reason to call MSBuild directly.
3. For focused work, `cd` to the folder containing the changed `.sln`, `.slnf`, `.csproj`, or `.vcxproj` before using `build.cmd`.
4. Exit code `0` is success; any non-zero exit code is failure.
5. On failure, inspect the matching `build.<configuration>.<platform>.errors.log` first, then the `.all.log` or `.binlog` if needed.

## Tests

Use the test project closest to the changed code.

- Toolkit changes: start with `src/modules/cmdpal/Tests/Microsoft.CommandPalette.Extensions.Toolkit.UnitTests/`.
- UI view model changes: start with `src/modules/cmdpal/Tests/Microsoft.CmdPal.UI.ViewModels.UnitTests/`.
- Extension changes: look under `src/modules/cmdpal/Tests/` for the matching extension test project.
- UI automation changes may require the existing UI test setup and a built app package.

Build the relevant test project first. Prefer Visual Studio Test Explorer or `vstest.console.exe`; do not use `dotnet test` as the default test runner in this repository.

## Standalone Validation

Run the standalone validator when changing:

- `MagicalGirlWand.slnx`
- Any `src/modules/cmdpal/**/*.slnf`, `.csproj`, or `.vcxproj`
- `src/common/` or `src/settings-ui/Settings.UI.Library/` dependencies used by CmdPal
- `tools/build/` or `tools/cmdpal/`
- Root documentation that describes repository scope or retained paths

Command:

```powershell
pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1
```

If the validator reports a missing keep root, update `tools/cmdpal/standalone-keep-roots.txt` only after confirming the referenced path is intentionally retained or intentionally removed.

## Areas Requiring Extra Care

| Area | Concern |
|------|---------|
| `src/modules/cmdpal/extensionsdk/Microsoft.CommandPalette.Extensions/` | ABI and WinRT contract compatibility |
| `src/modules/cmdpal/extensionsdk/Microsoft.CommandPalette.Extensions.Toolkit/` | Extension author API behavior and package compatibility |
| `src/modules/cmdpal/Microsoft.CmdPal.UI/` | User-facing behavior, settings migration, localization, and app packaging |
| `src/modules/cmdpal/Microsoft.CmdPal.UI.ViewModels/` | Command routing, extension lifecycle, gallery state, and settings persistence |
| `src/common/` | Shared dependency changes can affect many retained projects |
| `installer/` | Packaging and release impact |
| Elevation, startup, policy, or shell integration code | Security and Windows behavior regressions |

Ask for clarification before changing security-sensitive behavior, installer behavior, public extension contracts, or anything that expands this repo back toward the full PowerToys scope.

## What Not To Do

- Do not restore upstream PowerToys documentation just because a deleted link used to point there.
- Do not document features that are not present in the current MagicalGirlWand build.
- Do not add new third-party dependencies without updating `NOTICE.md` and explaining the reason.
- Do not break IPC, JSON settings contracts, or extension contracts without updating both producer and consumer code.
- Do not add noisy logs in hot paths.
- Do not commit local-only AI assistant files or generated planning notes.

## Validation Checklist

Before finishing a change, verify the level appropriate to the risk:

- [ ] Docs-only scope: `git diff --check`
- [ ] Standalone scope or retained path changes: `pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1`
- [ ] Code changes: build the changed project or solution successfully
- [ ] Behavior changes: add or update targeted tests and run them
- [ ] Dependency changes: update `NOTICE.md` if needed
- [ ] Summary cites exact changed paths and any skipped validation
