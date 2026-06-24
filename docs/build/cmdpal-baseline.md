# CmdPal build baseline

Recorded on 2026-06-24 in `A:\Code\MagicalGirlWand`.

## Repository

- Branch: `cmdpal-standalone`
- Fork HEAD while recording: `2eb689fd80700b43e81469ad7381efaf72662cf7`
- Unmodified PowerToys/CmdPal source baseline: `80f2b9b07d56b2a8d27d73663e9c79751df81595`
- `origin`: `https://github.com/LingMoe404/MagicalGirlWand.git`
- `upstream`: `https://github.com/microsoft/PowerToys.git`
- `CommandPalette.slnf` contains 56 explicit projects and resolves additional transitive project references.

## Toolchain

- Visual Studio Community 2026 18.7.1 (`18.7.11911.148`)
- MSBuild `18.7.8.30822`
- Windows SDK `10.0.26100.0`
- .NET SDK `10.0.301`
- MSVC tools `14.51.36231`
- Configuration: `Debug|x64`

## Default upstream command

The default restore command was run without source changes:

```powershell
$msbuild = 'C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe'
& $msbuild src\modules\cmdpal\CommandPalette.slnf `
  /restore /m `
  /p:Platform=x64 `
  /p:Configuration=Debug `
  /p:RestorePackagesConfig=true
```

Exit code: `1`.

The first actionable error was `MSB8040`: the installed MSVC 14.51 toolset does not include the x64/x86 Spectre-mitigated libraries. Visual Studio catalog identifies the missing components as:

- `Microsoft.VisualStudio.Component.VC.14.51.x86.x64.Spectre`
- `Microsoft.VisualStudio.Component.VC.14.51.ARM64.Spectre` for the later ARM64 build

The default failure is preserved in `src/modules/cmdpal/build.debug.x64.restore.errors.log` locally.

## Reproducible local baseline

On this zh-CN machine, the source also needs an explicit UTF-8 compiler input setting; otherwise `Microsoft.Terminal.UI/til_string.h` raises `C4819`, which becomes `C2220` because warnings are errors. With the missing Spectre component disabled as a global build property, restore succeeds:

```powershell
$env:CL = '/utf-8'
$msbuild = 'C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe'
& $msbuild src\modules\cmdpal\CommandPalette.slnf `
  /restore /m `
  /p:Platform=x64 `
  /p:Configuration=Debug `
  /p:RestorePackagesConfig=true `
  /p:SpectreMitigation=false
```

Restore exit code: `0`.

The first vcpkg pass encountered curl error 35 on the primary MSYS2 mirror. vcpkg successfully used its secondary mirror and populated the cache, but MSBuild treated the emitted error text as a failed task. Re-running the same command from the populated cache exited `0`.

The separate build command was:

```powershell
$env:CL = '/utf-8'
& $msbuild src\modules\cmdpal\CommandPalette.slnf `
  /m `
  /p:Platform=x64 `
  /p:Configuration=Debug `
  /p:SpectreMitigation=false
```

Build exit code: `0`. Both successful error-only logs were empty.

## Outputs and dependency observations

- CmdPal output: `x64\Debug\WinUI3Apps\CmdPal`
- Main host assembly: `x64\Debug\WinUI3Apps\CmdPal\Microsoft.CmdPal.UI.dll`
- Files below the CmdPal output after the build: 1,497
- The filtered build resolved projects outside the 56 explicit entries, including `MouseJump.Common`, `PowerDisplay.Models`, and `ZoomItSettingsInterop`. The standalone dependency closure must retain or remove these references deliberately rather than assuming the solution-filter list is complete.
