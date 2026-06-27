---
description: 'Guidelines for CmdPal settings and retained settings library code'
applyTo: 'src/settings-ui/**,src/modules/cmdpal/**'
---

# CmdPal Settings Guidance

This repository no longer contains the full PowerToys runner. Treat `src/settings-ui/Settings.UI.Library/` as retained shared settings code used by the standalone CmdPal graph, not as the full PowerToys Settings app product surface.

## Scope

- CmdPal settings models and serialization.
- Shortcut and conflict-related settings used by CmdPal.
- Settings dependencies consumed by `src/modules/cmdpal/`.
- Retained shared code needed to keep the standalone solution building.

## Guidelines

- Do not reintroduce `src/runner/` assumptions or full PowerToys module lifecycle documentation.
- Do not break persisted JSON settings silently; add migration or compatibility handling when shapes change.
- If a setting is consumed by CmdPal UI and a shared settings model, update both sides in the same change.
- Keep UI and settings work responsive; marshal to the UI thread for UI-bound operations.
- Reuse existing styles, resources, and settings helpers instead of adding duplicate patterns.
- Add or update serialization and view model tests when settings behavior changes.

## Validation

- Build the affected project or solution with `tools\build\build.cmd` or `tools\build\build.ps1`.
- Run targeted tests under `src/modules/cmdpal/Tests/` for CmdPal view model or settings changes.
- Run `pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1` when changing retained paths or project references.
