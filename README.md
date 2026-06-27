<p align="center">
  <img src="src/modules/cmdpal/Microsoft.CmdPal.UI/Assets/MagicalGirlWand/StoreLogo.png" width="128" alt="MagicalGirlWand logo" />
</p>

<h1 align="center">MagicalGirlWand</h1>

<p align="center">
  Standalone CmdPal, rebadged and trimmed to the pieces this repo actually ships.
</p>

<p align="center">
  <a href="#what-ships">What ships</a>
  <span> · </span>
  <a href="#build">Build</a>
  <span> · </span>
  <a href="#contributing">Contributing</a>
  <span> · </span>
  <a href="#license">License</a>
</p>

## What ships

- CmdPal launcher, bound by default to `Win+Alt+Space`
- the extension gallery and extension SDK
- the built-in create-extension flow and sample extensions
- MagicalGirlWand branding, assets, and settings

## Build

First build, or if NuGet packages are missing:

```powershell
tools\build\build-essentials.cmd
```

Then build the solution:

```powershell
tools\build\build.ps1 -Platform x64 -Configuration Debug
```

For a release build:

```powershell
tools\build\build.ps1 -Platform x64 -Configuration Release
```

## Contributing

Keep changes atomic and build before pushing. When changing CmdPal behavior, run the repo verifier and the relevant build or test target before you commit.

## License

See [LICENSE](LICENSE).
