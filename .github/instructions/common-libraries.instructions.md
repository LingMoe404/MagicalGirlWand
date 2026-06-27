---
description: 'Guidelines for retained shared libraries consumed by standalone CmdPal'
applyTo: 'src/common/**'
---

# Common Libraries – Shared Code Guidance

Guidelines for modifying retained shared code in `src/common/`. Changes here can affect many projects in the standalone CmdPal dependency graph, even when the code originated upstream in PowerToys.

## Scope

- Logging infrastructure (`src/common/logger/`)
- IPC primitives and named pipe utilities
- Settings serialization and management
- DPI awareness and scaling utilities
- Telemetry helpers
- General utilities (JSON parsing, string helpers, etc.)

## Guidelines

### API Stability

- Avoid breaking public headers/APIs; if changed, search and update all callers in the retained graph.
- Coordinate ABI-impacting struct/class layout changes; keep binary compatibility
- When modifying public interfaces, grep the entire codebase for usages

### Performance

- Watch perf in hot paths (hooks, timers, serialization)
- Avoid avoidable allocations in frequently called code
- Profile changes that touch performance-sensitive areas

### Dependencies

- Ask before adding third-party deps or changing serialization formats
- Do not add third-party dependencies unless they are necessary for MagicalGirlWand.
- Add any new external packages to `NOTICE.md`.

### Logging

- C++ logging uses spdlog (`Logger::info`, `Logger::warn`, `Logger::error`, `Logger::debug`)
- Initialize with `init_logger()` early in startup
- Keep hot paths quiet – no logging in tight loops or hooks

## Acceptance Criteria

- No unintended ABI breaks
- No noisy logs in hot paths
- New non-obvious symbols briefly commented
- All callers updated when interfaces change

## Code Style

- **C++**: Follow `.clang-format` in `src/`; use Modern C++ patterns per C++ Core Guidelines
- **C#**: Follow `src/.editorconfig`; enforce StyleCop.Analyzers

## Validation

- Build the changed project or solution with `tools\build\build.cmd` or `tools\build\build.ps1`.
- Verify no ABI breaks: grep for changed function/struct names across retained callers.
- Check logs: ensure no new logging in performance-critical paths.
- Run `pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1` when shared dependency paths or project references change.
