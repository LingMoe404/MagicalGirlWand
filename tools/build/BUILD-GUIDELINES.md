# Build Scripts - Quick Guideline

Use these scripts to build MagicalGirlWand locally. They initialize the Visual Studio developer environment, restore dependencies, and write logs on failure.

## Quick Start

From the repository root:

```powershell
tools\build\build-essentials.cmd
tools\build\build.ps1 -Platform x64 -Configuration Debug
```

For a focused project or solution filter, `cd` to the folder containing the `.sln`, `.slnf`, `.csproj`, or `.vcxproj`, then run:

```powershell
tools\build\build.cmd
```

## When To Use Which

| Script | Use |
| --- | --- |
| `build-essentials.cmd` / `build-essentials.ps1` | First build or NuGet restore/bootstrap work |
| `build.cmd` / `build.ps1` | Build the solution or project in the current folder |
| `build-installer.ps1` | Installer/package work only; use with care |

## Common Commands

```powershell
# Restore/bootstrap essentials
tools\build\build-essentials.cmd

# Build Debug x64
tools\build\build.ps1 -Platform x64 -Configuration Debug

# Build Release x64
tools\build\build.ps1 -Platform x64 -Configuration Release

# Restore only
tools\build\build.ps1 -RestoreOnly
```

## Standalone CmdPal Validation

When changing project references, retained dependency paths, build scripts, or repository-scope documentation, run:

```powershell
pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1
```

This validates `MagicalGirlWand.slnx`, the CmdPal solution filters, and the standalone dependency keep manifest.

## Logs and Troubleshooting

On failure, check logs next to the solution or project being built:

- `build.<configuration>.<platform>.errors.log` - errors only; check this first.
- `build.<configuration>.<platform>.warnings.log` - warnings only.
- `build.<configuration>.<platform>.all.log` - full text log.
- `build.<configuration>.<platform>.trace.binlog` - open with MSBuild Structured Log Viewer.

The scripts try DevShell first (`Microsoft.VisualStudio.DevShell.dll` / `Enter-VsDevShell`), then fall back to `VsDevCmd.bat`.

If Visual Studio is not found, run from "Developer PowerShell for VS 2022" or "Developer PowerShell for VS", or ensure `vswhere.exe` exists under `Program Files (x86)\Microsoft Visual Studio\Installer`.

## Notes

- Override platform explicitly with `-Platform x64|arm64` when needed.
- CMD wrappers forward all arguments to the PowerShell scripts.
- Do not assume the full upstream PowerToys solution exists in this repository.
