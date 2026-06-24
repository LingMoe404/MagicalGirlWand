# MagicalGirlWand Standalone CmdPal Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Produce an installable, independently buildable MagicalGirlWand fork of PowerToys Command Palette that retains all CmdPal capabilities, removes unrelated PowerToys modules, defaults to `Alt + Space`, and adds an Everything-backed dynamic file-search provider.

**Architecture:** Preserve `src/modules/cmdpal` and its full transitive build closure, then replace the full PowerToys solution entry point with a standalone `MagicalGirlWand.slnx`. Keep upstream `Microsoft.CmdPal.*` namespaces for mergeability. Add Everything as an in-process `ICommandProvider` with a `DynamicListPage`, a cancellable native SDK adapter, and a fallback item coordinated with the existing Indexer provider.

**Tech Stack:** C#/.NET 10, C++/WinRT, WinUI 3, Windows App SDK, MSBuild/Visual Studio, MSTest, Microsoft.CommandPalette.Extensions Toolkit, Everything SDK native DLLs, PowerShell.

---

## File and component map

### Build and repository boundary

- Create `MagicalGirlWand.slnx`: standalone solution containing every project from `src/modules/cmdpal/CommandPalette.slnf` and its explicit build dependencies.
- Create `tools/cmdpal/Get-CmdPalDependencyClosure.ps1`: derive project/import/resource dependencies from the solution filter.
- Create `tools/cmdpal/Verify-CmdPalStandalone.ps1`: reject missing project/import paths and references to deleted source roots.
- Create `docs/build/cmdpal-baseline.md`: authoritative baseline environment, commands, output locations, and limitations.
- Modify `README.md`: MagicalGirlWand build/install/upstream documentation.

### Branding and configuration

- Modify `src/modules/cmdpal/custom.props`: product display name and standalone version metadata.
- Modify `src/modules/cmdpal/Microsoft.CmdPal.UI/CmdPal.Branding.props`: MagicalGirlWand assets and manifests.
- Modify `src/modules/cmdpal/Microsoft.CmdPal.UI/Package.appxmanifest`.
- Modify `src/modules/cmdpal/Microsoft.CmdPal.UI/Package-Dev.appxmanifest`.
- Modify `src/modules/cmdpal/Microsoft.CmdPal.UI.ViewModels/SettingsModel.cs`: default `Alt + Space` hotkey.
- Modify `src/modules/cmdpal/Microsoft.CmdPal.Common/Services/ApplicationInfoService.cs`: independent settings directory.
- Modify localized `Resources.resw` values containing the application name.
- Add MagicalGirlWand application assets under `src/modules/cmdpal/Microsoft.CmdPal.UI/Assets/MagicalGirlWand/`.

### Everything provider

- Create `src/modules/cmdpal/ext/Microsoft.CmdPal.Ext.Everything/Microsoft.CmdPal.Ext.Everything.csproj`.
- Create `EverythingCommandsProvider.cs`: provider registration surface.
- Create `EverythingQuery.cs`, `EverythingSearchResult.cs`, `IEverythingSearchService.cs`: testable domain contracts.
- Create `EverythingNativeMethods.cs`, `EverythingSearchService.cs`: serialized native SDK adapter.
- Create `Pages/EverythingPage.cs`: cancellable, paged `DynamicListPage`.
- Create `FallbackEverythingItem.cs`: root fallback behavior.
- Create `Data/EverythingListItem.cs`: CmdPal result item and context commands.
- Create `EverythingAvailabilityCoordinator.cs`: suppress/restore Indexer fallback.
- Add `Native/x64/Everything64.dll` and `Native/arm64/EverythingARM64.dll`.
- Add localized resources and icons.
- Modify `src/modules/cmdpal/Microsoft.CmdPal.UI/App.xaml.cs`: register the Everything provider and fallback coordination.
- Modify CmdPal project/solution files to build and package the provider.

### Everything tests

- Create `src/modules/cmdpal/Tests/Microsoft.CmdPal.Ext.Everything.UnitTests/Microsoft.CmdPal.Ext.Everything.UnitTests.csproj`.
- Create `FakeEverythingSearchService.cs`.
- Create `EverythingSearchServiceTests.cs`.
- Create `EverythingPageTests.cs`.
- Create `FallbackEverythingItemTests.cs`.
- Create `EverythingAvailabilityCoordinatorTests.cs`.
- Modify `MagicalGirlWand.slnx` to include the new test project.

## Task 1: Establish and publish the upstream CmdPal baseline

**Files:**
- Create: `docs/build/cmdpal-baseline.md`
- Read: `AGENTS.md`
- Read: `tools/build/BUILD-GUIDELINES.md`
- Read: `src/modules/cmdpal/CommandPalette.slnf`

- [ ] **Step 1: Record the exact repository baseline**

Run:

```powershell
$git = 'D:\Program Files\Git\cmd\git.exe'
& $git status --short --branch
& $git rev-parse HEAD
& $git remote -v
& 'C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe' `
  -latest -products * -requires Microsoft.Component.MSBuild `
  -format json
```

Expected: branch `cmdpal-standalone`, clean status, `origin` points to `LingMoe404/MagicalGirlWand`, `upstream` points to `microsoft/PowerToys`, and Visual Studio with MSBuild is listed.

- [ ] **Step 2: Restore the unmodified Command Palette solution filter**

Run from a Visual Studio developer PowerShell:

```powershell
msbuild src\modules\cmdpal\CommandPalette.slnf `
  /restore /m `
  /p:Platform=x64 `
  /p:Configuration=Debug `
  /p:RestorePackagesConfig=true
```

Expected: exit code `0`. On failure, inspect `src/modules/cmdpal/build.debug.x64.errors.log` or the emitted MSBuild errors before changing source.

- [ ] **Step 3: Build the unmodified x64 Debug CmdPal graph**

Run:

```powershell
msbuild src\modules\cmdpal\CommandPalette.slnf `
  /m `
  /p:Platform=x64 `
  /p:Configuration=Debug
```

Expected: exit code `0`, with CmdPal output under `x64\Debug\WinUI3Apps\CmdPal`.

- [ ] **Step 4: Record baseline results**

Create `docs/build/cmdpal-baseline.md`. Record the fixed upstream commit, x64/Debug configuration, and the exact restore/build commands from Steps 2 and 3. Add the actual exit codes, detected Visual Studio/Windows SDK versions, output path, and the first actionable error for any failed command. The document must contain observations only; omit sections for which there was no limitation or error.

- [ ] **Step 5: Commit and push the baseline**

```powershell
git add docs/build/cmdpal-baseline.md
git commit -m "docs: record CmdPal build baseline"
git push -u origin cmdpal-standalone
```

Expected: the branch and both design/plan history are visible on `origin`.

## Task 2: Build the standalone dependency graph and solution

**Files:**
- Create: `tools/cmdpal/Get-CmdPalDependencyClosure.ps1`
- Create: `tools/cmdpal/Verify-CmdPalStandalone.ps1`
- Create: `MagicalGirlWand.slnx`
- Test: `tools/cmdpal/Verify-CmdPalStandalone.ps1`

- [ ] **Step 1: Write the closure script self-test first**

At the bottom of `Get-CmdPalDependencyClosure.ps1`, expose functions without executing when dot-sourced. Add `tools/cmdpal/Verify-CmdPalStandalone.ps1` assertions that fail when a temporary project references a missing project:

```powershell
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\Get-CmdPalDependencyClosure.ps1"

$filter = Join-Path $RepoRoot 'src\modules\cmdpal\CommandPalette.slnf'
$projects = Get-SolutionFilterProjects -FilterPath $filter
if ($projects.Count -lt 50) {
    throw "Expected the CmdPal filter to contain at least 50 projects; got $($projects.Count)."
}

$missing = Get-MissingProjectDependencies -ProjectPaths $projects
if ($missing.Count -ne 0) {
    $missing | ForEach-Object { Write-Error $_ }
    throw "CmdPal project graph contains missing dependencies."
}
```

- [ ] **Step 2: Run the self-test and verify it fails**

Run:

```powershell
pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1
```

Expected: failure because `Get-SolutionFilterProjects` is not defined.

- [ ] **Step 3: Implement dependency discovery**

Implement these functions in `Get-CmdPalDependencyClosure.ps1`:

```powershell
function Get-SolutionFilterProjects {
    param([Parameter(Mandatory)][string]$FilterPath)
    $json = Get-Content -Raw -LiteralPath $FilterPath | ConvertFrom-Json
    return @($json.solution.projects | ForEach-Object {
        [IO.Path]::GetFullPath((Join-Path $RepoRoot $_))
    })
}

function Get-ProjectReferences {
    param([Parameter(Mandatory)][string]$ProjectPath)
    [xml]$xml = Get-Content -Raw -LiteralPath $ProjectPath
    $projectDir = Split-Path -Parent $ProjectPath
    return @($xml.Project.ItemGroup.ProjectReference.Include | ForEach-Object {
        [IO.Path]::GetFullPath((Join-Path $projectDir $_))
    })
}

function Get-MissingProjectDependencies {
    param([Parameter(Mandatory)][string[]]$ProjectPaths)
    $missing = [Collections.Generic.List[string]]::new()
    foreach ($project in $ProjectPaths) {
        if (!(Test-Path -LiteralPath $project)) {
            $missing.Add("Missing project: $project")
            continue
        }
        foreach ($reference in Get-ProjectReferences -ProjectPath $project) {
            if (!(Test-Path -LiteralPath $reference)) {
                $missing.Add("$project -> $reference")
            }
        }
    }
    return $missing
}
```

Also collect literal MSBuild `Import Project=`, linked `Compile Include=`, `AdditionalFiles`, and content/resource paths. Preserve paths containing unevaluated MSBuild properties for the later MSBuild verification step instead of guessing their expansion.

- [ ] **Step 4: Generate `MagicalGirlWand.slnx`**

Generate a solution with the upstream platforms and every CmdPal filter project:

```xml
<Solution>
  <Configurations>
    <Platform Name="ARM64" />
    <Platform Name="x64" />
  </Configurations>
  <Folder Name="/CmdPal/">
    <!-- one Project element for each src/modules/cmdpal project -->
  </Folder>
  <Folder Name="/Dependencies/">
    <!-- one Project element for each retained src/common and Settings.UI.Library project -->
  </Folder>
</Solution>
```

Copy project IDs and platform mappings from `PowerToys.slnx` where present. Do not include unrelated PowerToys projects.

- [ ] **Step 5: Verify and build the standalone solution**

Run:

```powershell
pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1
msbuild MagicalGirlWand.slnx /restore /m /p:Platform=x64 /p:Configuration=Debug
```

Expected: verifier exit `0`; MSBuild exit `0`.

- [ ] **Step 6: Commit and push**

```powershell
git add MagicalGirlWand.slnx tools/cmdpal
git commit -m "build: add standalone CmdPal solution graph"
git push
```

## Task 3: Remove unrelated PowerToys source in verified batches

**Files:**
- Create: `tools/cmdpal/standalone-keep-roots.txt`
- Modify: `tools/cmdpal/Verify-CmdPalStandalone.ps1`
- Delete: PowerToys roots outside the verified CmdPal dependency closure

- [ ] **Step 1: Create the explicit keep manifest**

`tools/cmdpal/standalone-keep-roots.txt` must contain normalized repository-relative roots, including:

```text
src/modules/cmdpal
src/common/CalculatorEngineCommon
src/common/Common.UI.Controls
src/common/ManagedCommon
src/common/ManagedCsWin32
src/common/ManagedTelemetry/Telemetry
src/common/SettingsAPI
src/common/UITestAutomation
src/common/interop
src/common/logger
src/common/version
src/settings-ui/Settings.UI.Library
src/codeAnalysis
tools/build
tools/cmdpal
doc/devdocs/development
```

Append every additional root proven necessary by the Task 2 closure output. Keep root-level build, package, license, formatting, and version files referenced by retained projects.

- [ ] **Step 2: Make the verifier reject references outside the manifest**

Add this check:

```powershell
$allowedRoots = Get-Content -LiteralPath (Join-Path $RepoRoot 'tools\cmdpal\standalone-keep-roots.txt')
$outside = Get-ResolvedCmdPalDependencies | Where-Object {
    $relative = [IO.Path]::GetRelativePath($RepoRoot, $_).Replace('\', '/')
    -not ($allowedRoots | Where-Object { $relative -eq $_ -or $relative.StartsWith("$_/") })
}
if ($outside) {
    $outside | ForEach-Object { Write-Error "Dependency outside keep manifest: $_" }
    throw 'Standalone keep manifest is incomplete.'
}
```

- [ ] **Step 3: Run the verifier before deleting**

```powershell
pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1
```

Expected: exit `0` and a complete retained-root report.

- [ ] **Step 4: Delete unrelated module batches**

Use `git rm -r` on top-level module directories not named `cmdpal`, then remove unrelated runner, installer, update, settings UI, and common roots only when they are absent from the keep manifest. After each batch run:

```powershell
pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1
msbuild MagicalGirlWand.slnx /m /p:Platform=x64 /p:Configuration=Debug
```

Expected: both commands exit `0` before starting the next batch.

- [ ] **Step 5: Remove the full PowerToys solution entry point**

After `MagicalGirlWand.slnx` builds from a clean checkout, remove `PowerToys.slnx` and scripts that only build unrelated products. Update retained scripts so repository-root discovery uses `MagicalGirlWand.slnx`.

- [ ] **Step 6: Commit and push each successful deletion batch**

Use atomic commit messages:

```powershell
git commit -m "chore: remove unrelated PowerToys modules"
git push
git commit -m "chore: trim unrelated PowerToys infrastructure"
git push
```

Do not combine a failing deletion batch with the previous successful batch.

## Task 4: Rebrand the standalone application and set `Alt + Space`

**Files:**
- Modify: `src/modules/cmdpal/custom.props`
- Modify: `src/modules/cmdpal/Microsoft.CmdPal.UI/CmdPal.Branding.props`
- Modify: `src/modules/cmdpal/Microsoft.CmdPal.UI/Package.appxmanifest`
- Modify: `src/modules/cmdpal/Microsoft.CmdPal.UI/Package-Dev.appxmanifest`
- Modify: `src/modules/cmdpal/Microsoft.CmdPal.UI.ViewModels/SettingsModel.cs:16`
- Modify: `src/modules/cmdpal/Microsoft.CmdPal.Common/Services/ApplicationInfoService.cs:23,102,118`
- Test: `src/modules/cmdpal/Tests/Microsoft.CmdPal.UI.ViewModels.UnitTests/SettingsModelDefaultsTests.cs`
- Create: `src/modules/cmdpal/Microsoft.CmdPal.UI/Assets/MagicalGirlWand/*`

- [ ] **Step 1: Add a failing default-hotkey test**

```csharp
[TestClass]
public sealed class SettingsModelDefaultsTests
{
    [TestMethod]
    public void DefaultActivationShortcutIsAltSpace()
    {
        var hotkey = SettingsModel.DefaultActivationShortcut;
        Assert.IsFalse(hotkey.Win);
        Assert.IsFalse(hotkey.Ctrl);
        Assert.IsFalse(hotkey.Shift);
        Assert.IsTrue(hotkey.Alt);
        Assert.AreEqual(0x20, hotkey.Code);
    }
}
```

- [ ] **Step 2: Run the targeted test and verify it fails**

Build the test project, then run it with `vstest.console.exe` as required by `AGENTS.md`.

Expected: failure because the upstream default sets `Win=true`.

- [ ] **Step 3: Change the default hotkey**

```csharp
public static HotkeySettings DefaultActivationShortcut { get; }
    = new HotkeySettings(false, false, false, true, 0x20); // alt+space
```

- [ ] **Step 4: Apply user-visible branding**

Set:

```xml
<VersionInfoProductName>MagicalGirlWand</VersionInfoProductName>
```

Use package identities `LingMoe404.MagicalGirlWand` and `LingMoe404.MagicalGirlWand.Dev`, publisher display name `LingMoe404`, protocol `magicalgirlwand`, and a new fixed PhoneProductId. Preserve `com.microsoft.commandpalette` as the extension host contract so existing CmdPal extensions continue to work.

Change `ApplicationInfoService` settings roots from `Microsoft.CmdPal` to `MagicalGirlWand`. Update every `AppName`, `AppNameDev`, `AppDescription`, and startup-task resource to MagicalGirlWand text while leaving command and SDK terminology unchanged.

- [ ] **Step 5: Add branded assets**

Convert the existing MagicalGirlWand icon from `A:\Code\MagicalGirlWand-backup\app.ico` into the sizes required by the package asset set. Preserve the upstream asset filenames so XAML and manifests do not need path rewrites. Render or inspect every generated asset before committing.

- [ ] **Step 6: Run tests and package build**

```powershell
msbuild MagicalGirlWand.slnx /m /p:Platform=x64 /p:Configuration=Debug
```

Run the targeted hotkey test and inspect the generated app manifest. Expected: build and test exit `0`; generated identity and display resources use MagicalGirlWand.

- [ ] **Step 7: Commit and push**

```powershell
git add src/modules/cmdpal
git commit -m "feat: rebrand CmdPal as MagicalGirlWand"
git push
```

## Task 5: Scaffold the Everything provider and its contracts

**Files:**
- Create: `src/modules/cmdpal/ext/Microsoft.CmdPal.Ext.Everything/Microsoft.CmdPal.Ext.Everything.csproj`
- Create: `EverythingQuery.cs`
- Create: `EverythingSearchResult.cs`
- Create: `IEverythingSearchService.cs`
- Create: `src/modules/cmdpal/Tests/Microsoft.CmdPal.Ext.Everything.UnitTests/Microsoft.CmdPal.Ext.Everything.UnitTests.csproj`
- Create: `FakeEverythingSearchService.cs`
- Modify: `MagicalGirlWand.slnx`

- [ ] **Step 1: Add the project and domain records**

```csharp
internal enum EverythingFilter { All, Files, Folders }

internal sealed record EverythingQuery(
    string SearchText,
    int Offset,
    int Count,
    EverythingFilter Filter = EverythingFilter.All,
    int Sort = 1);

internal sealed record EverythingSearchResult(
    string Name,
    string ParentPath,
    bool IsDirectory,
    long Size,
    DateTime Modified)
{
    public string FullPath => Path.Combine(ParentPath, Name);
}

internal sealed record EverythingQueryResult(
    IReadOnlyList<EverythingSearchResult> Items,
    bool HasMoreItems,
    bool IsAvailable,
    string? ErrorMessage = null);

internal interface IEverythingSearchService
{
    Task<EverythingQueryResult> QueryAsync(EverythingQuery query, CancellationToken cancellationToken);
}
```

- [ ] **Step 2: Add the fake service**

```csharp
internal sealed class FakeEverythingSearchService : IEverythingSearchService
{
    public List<EverythingQuery> Queries { get; } = [];
    public Func<EverythingQuery, CancellationToken, Task<EverythingQueryResult>> Handler { get; set; }
        = (_, _) => Task.FromResult(new EverythingQueryResult([], false, true));

    public Task<EverythingQueryResult> QueryAsync(EverythingQuery query, CancellationToken cancellationToken)
    {
        Queries.Add(query);
        return Handler(query, cancellationToken);
    }
}
```

- [ ] **Step 3: Build the contract project and tests**

Expected: both projects compile after adding them to `MagicalGirlWand.slnx`; no provider page or native Everything DLL is loaded by tests.

- [ ] **Step 4: Commit and push**

```powershell
git add MagicalGirlWand.slnx src/modules/cmdpal/ext/Microsoft.CmdPal.Ext.Everything src/modules/cmdpal/Tests/Microsoft.CmdPal.Ext.Everything.UnitTests
git commit -m "feat: scaffold Everything command provider"
git push
```

## Task 6: Implement the native Everything search adapter with TDD

**Files:**
- Create: `EverythingNativeMethods.cs`
- Create: `EverythingSearchService.cs`
- Test: `EverythingSearchServiceTests.cs`

- [ ] **Step 1: Write adapter-independent behavior tests**

Use an internal `IEverythingNativeApi` injected into `EverythingSearchService`. Test:

```csharp
[TestMethod]
public async Task EmptyQueryDoesNotCallNativeApi()
{
    var native = new FakeEverythingNativeApi();
    var service = new EverythingSearchService(native);
    var result = await service.QueryAsync(new EverythingQuery("", 0, 20), CancellationToken.None);
    Assert.AreEqual(0, native.QueryCount);
    Assert.AreEqual(0, result.Items.Count);
}

[TestMethod]
public async Task OffsetAndCountProducePagedResult()
{
    var native = FakeEverythingNativeApi.WithResults(30);
    var service = new EverythingSearchService(native);
    var result = await service.QueryAsync(new EverythingQuery("file", 10, 5), CancellationToken.None);
    CollectionAssert.AreEqual(
        new[] { "file10", "file11", "file12", "file13", "file14" },
        result.Items.Select(x => x.Name).ToArray());
    Assert.IsTrue(result.HasMoreItems);
}
```

- [ ] **Step 2: Run tests and verify they fail**

Expected: failure because `EverythingSearchService` and native abstraction do not exist.

- [ ] **Step 3: Implement serialized native access**

`EverythingSearchService` must use a process-wide `SemaphoreSlim(1, 1)` because the Everything SDK stores query state globally. Request `Offset + Count + 1` native results, skip `Offset`, take `Count`, and set `HasMoreItems` from the extra row. Apply Everything filters by prefixing `file:` or `folder:` to the query.

The native implementation must expose the exact SDK calls used by the old project: `Everything_SetSearchW`, `Everything_SetMax`, `Everything_SetSort`, `Everything_SetRequestFlags`, `Everything_QueryW`, `Everything_GetNumResults`, result name/path/attributes/size/date accessors, and `Everything_GetLastError`.

- [ ] **Step 4: Implement architecture-specific loading**

Use `NativeLibrary.SetDllImportResolver` once. Map `Architecture.X64` to `Everything64.dll` and `Architecture.Arm64` to `EverythingARM64.dll`. Reject unsupported architecture with a descriptive `PlatformNotSupportedException` that the service converts to `IsAvailable=false`.

- [ ] **Step 5: Run adapter tests**

Expected: empty query, pagination, file/folder filter, cancellation, missing DLL, and native query failure tests all pass without loading a real native DLL.

- [ ] **Step 6: Commit and push**

```powershell
git add src/modules/cmdpal/ext/Microsoft.CmdPal.Ext.Everything src/modules/cmdpal/Tests/Microsoft.CmdPal.Ext.Everything.UnitTests
git commit -m "feat: add Everything native search adapter"
git push
```

## Task 7: Implement Everything list items and context commands

**Files:**
- Create: `Data/EverythingListItem.cs`
- Create: `Icons.cs`
- Create: localized `Properties/Resources.resx` and generated designer
- Test: `EverythingListItemTests.cs`

- [ ] **Step 1: Write failing item tests**

Verify title, subtitle, full path, default command, and context-command count for both a file and directory. The file test must assert that copy-path and show-in-folder commands are present; the directory test must assert that opening the directory is the default.

- [ ] **Step 2: Reuse CmdPal file commands**

Build `EverythingListItem` with CmdPal Toolkit types and the existing command implementations used by Indexer:

```csharp
internal sealed partial class EverythingListItem : ListItem
{
    internal EverythingSearchResult Result { get; }

    public EverythingListItem(EverythingSearchResult result)
    {
        Result = result;
        Title = result.Name;
        Subtitle = result.ParentPath;
        DataPackage = DataPackageHelper.CreateDataPackageForPath(this, result.FullPath);

        var commands = FileCommands(result.FullPath).ToArray();
        Command = commands.FirstOrDefault()?.Command;
        MoreCommands = commands.Skip(1).Cast<IContextItem>().ToArray();
    }

    private static IEnumerable<CommandContextItem> FileCommands(string fullPath)
    {
        yield return new CommandContextItem(new OpenFileCommand(fullPath));
        yield return new CommandContextItem(new OpenWithCommand(fullPath));
        yield return new CommandContextItem(new ShowFileInFolderCommand(fullPath));
        yield return new CommandContextItem(new CopyPathCommand(fullPath));
        yield return new CommandContextItem(new OpenInConsoleCommand(fullPath));
        yield return new CommandContextItem(new OpenPropertiesCommand(fullPath));
    }
}
```

The Everything extension may assemble its own context list, but it must reuse the Toolkit command implementations. Do not copy shell, clipboard, elevation, or process-launch implementation code from Indexer.

- [ ] **Step 3: Add details and icons**

Populate `Details` with path, type, size, and modified time. Use `ThumbnailHelper` asynchronously where available and fall back to file/folder icons without blocking `GetItems()`.

- [ ] **Step 4: Run item tests**

Expected: all file/directory metadata and command tests pass.

- [ ] **Step 5: Commit and push**

```powershell
git add src/modules/cmdpal/ext/Microsoft.CmdPal.Ext.Everything src/modules/cmdpal/ext/Microsoft.CmdPal.Ext.Indexer src/modules/cmdpal/Microsoft.CmdPal.Common src/modules/cmdpal/Tests
git commit -m "feat: add Everything result items and actions"
git push
```

## Task 8: Implement the cancellable dynamic Everything page

**Files:**
- Create: `Pages/EverythingPage.cs`
- Create: `SearchFilters.cs`
- Test: `EverythingPageTests.cs`

- [ ] **Step 1: Write failing dynamic-page tests**

Cover:

```csharp
[TestMethod]
public async Task NewSearchCancelsOldSearchAndPublishesOnlyLatestItems()
{
    var fake = new FakeEverythingSearchService();
    var firstRelease = new TaskCompletionSource<EverythingQueryResult>();
    fake.Handler = (query, ct) => query.SearchText == "old"
        ? firstRelease.Task.WaitAsync(ct)
        : Task.FromResult(new EverythingQueryResult(
            [new EverythingSearchResult("new.txt", "C:\\Temp", false, 1, DateTime.UnixEpoch)],
            false,
            true));

    using var page = new EverythingPage(fake);
    page.SearchText = "old";
    page.SearchText = "new";
    await page.CurrentSearchTask.WaitAsync(TimeSpan.FromSeconds(5));
    CollectionAssert.AreEqual(new[] { "new.txt" }, page.GetItems().Select(x => x.Title).ToArray());
}
```

Also test empty query, `HasMoreItems`, `LoadMore`, filter changes, unavailable service, and `Dispose` cancellation.

- [ ] **Step 2: Implement query generations**

`EverythingPage` stores a `CancellationTokenSource`, an `int _generation`, an item list protected by `Lock`, and the current filter. `UpdateSearchText` increments the generation, swaps/cancels the CTS, and assigns `PerformSearchAsync` to an internal `Task CurrentSearchTask` exposed to the test assembly. Before publishing any result, require both `generation == _generation` and `!ct.IsCancellationRequested`.

- [ ] **Step 3: Implement pagination and empty states**

Initial query uses `Offset=0, Count=20`. `LoadMore` uses the current count as offset. Set `IsLoading`, `HasMoreItems`, and `EmptyContent` consistently and raise `ItemsChanged` after state is committed.

- [ ] **Step 4: Run page tests**

Expected: all cancellation, stale-result, filter, pagination, and error-state tests pass.

- [ ] **Step 5: Commit and push**

```powershell
git add src/modules/cmdpal/ext/Microsoft.CmdPal.Ext.Everything src/modules/cmdpal/Tests/Microsoft.CmdPal.Ext.Everything.UnitTests
git commit -m "feat: add Everything dynamic search page"
git push
```

## Task 9: Add Everything fallback and Indexer coordination

**Files:**
- Create: `EverythingCommandsProvider.cs`
- Create: `FallbackEverythingItem.cs`
- Create: `EverythingAvailabilityCoordinator.cs`
- Modify: `EverythingCommandsProvider.cs`
- Modify: `src/modules/cmdpal/ext/Microsoft.CmdPal.Ext.Indexer/IndexerCommandsProvider.cs`
- Test: `FallbackEverythingItemTests.cs`
- Test: `EverythingAvailabilityCoordinatorTests.cs`

- [ ] **Step 1: Write failing fallback tests**

Test empty query clears the item, exact existing path opens directly, one search result opens directly, multiple results navigate to `EverythingPage(query)`, superseded queries cannot publish, and unavailable Everything activates Indexer fallback.

- [ ] **Step 2: Implement the fallback item**

Derive from `FallbackCommandItem`. Use the same CTS/generation rule as `EverythingPage`. Query at most two rows: zero clears the fallback, one maps to `EverythingListItem`, and two or more set the command to a prefilled `EverythingPage`.

- [ ] **Step 3: Implement the provider**

```csharp
public sealed partial class EverythingCommandsProvider : CommandProvider
{
    internal const string ProviderId = "Files.Everything";
    private readonly IEverythingSearchService _searchService;
    private readonly FallbackEverythingItem _fallback;

    internal EverythingCommandsProvider(IEverythingSearchService searchService)
    {
        Id = ProviderId;
        DisplayName = "Everything";
        Icon = Icons.Everything;
        _searchService = searchService;
        _fallback = new FallbackEverythingItem(searchService);
    }

    public EverythingCommandsProvider() : this(new EverythingSearchService()) { }

    public override ICommandItem[] TopLevelCommands() =>
        [new CommandItem(new EverythingPage(_searchService)) { Title = "Search with Everything" }];

    public override IFallbackCommandItem[] FallbackCommands() => [_fallback];
}
```

- [ ] **Step 4: Add reversible Indexer suppression**

Extend Indexer with an explicit predicate that suppresses its fallback only while Everything reports available. `EverythingAvailabilityCoordinator` owns that predicate state. Do not disable Indexer top-level commands or its page.

- [ ] **Step 5: Run fallback and coordination tests**

Expected: fallback behavior and availability transitions pass without native Everything.

- [ ] **Step 6: Commit and push**

```powershell
git add src/modules/cmdpal/ext/Microsoft.CmdPal.Ext.Everything src/modules/cmdpal/ext/Microsoft.CmdPal.Ext.Indexer src/modules/cmdpal/Tests
git commit -m "feat: integrate Everything fallback search"
git push
```

## Task 10: Wire, package, and license Everything

**Files:**
- Modify: `src/modules/cmdpal/Microsoft.CmdPal.UI/App.xaml.cs:147-205`
- Modify: `src/modules/cmdpal/Microsoft.CmdPal.UI/Microsoft.CmdPal.UI.csproj`
- Modify: `MagicalGirlWand.slnx`
- Add: `src/modules/cmdpal/ext/Microsoft.CmdPal.Ext.Everything/Native/x64/Everything64.dll`
- Add: `src/modules/cmdpal/ext/Microsoft.CmdPal.Ext.Everything/Native/arm64/EverythingARM64.dll`
- Modify: `NOTICE.md`
- Create: `src/modules/cmdpal/ext/Microsoft.CmdPal.Ext.Everything/LICENSE-EVERYTHING.txt`

- [ ] **Step 1: Register the built-in provider**

In `AddBuiltInCommands`, instantiate `EverythingCommandsProvider`, coordinate it with `IndexerCommandsProvider`, and register both as `ICommandProvider` singletons in the desired home-page order.

- [ ] **Step 2: Package native binaries per architecture**

Use conditioned content entries:

```xml
<Content Include="Native\x64\Everything64.dll" Condition="'$(Platform)'=='x64'">
  <Link>Everything64.dll</Link>
  <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
</Content>
<Content Include="Native\arm64\EverythingARM64.dll" Condition="'$(Platform)'=='ARM64'">
  <Link>EverythingARM64.dll</Link>
  <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
</Content>
```

- [ ] **Step 3: Add license attribution**

Extract the Everything SDK license from the archived SDK in the backup repository, preserve it verbatim in `LICENSE-EVERYTHING.txt`, and add a matching `NOTICE.md` entry. Verify DLL hashes and record them in the provider README.

- [ ] **Step 4: Build x64 and ARM64 provider graphs**

```powershell
msbuild MagicalGirlWand.slnx /m /p:Platform=x64 /p:Configuration=Debug
msbuild MagicalGirlWand.slnx /m /p:Platform=ARM64 /p:Configuration=Debug
```

Expected: exit `0` for both build graphs; the correct native DLL exists once in each output.

- [ ] **Step 5: Commit and push**

```powershell
git add MagicalGirlWand.slnx NOTICE.md src/modules/cmdpal
git commit -m "build: package Everything with MagicalGirlWand"
git push
```

## Task 11: Build, test, install, and exercise the application

**Files:**
- Modify: `docs/build/cmdpal-baseline.md`
- Modify: `README.md`
- Create: `docs/build/install-and-smoke-test.md`

- [ ] **Step 1: Run the standalone verifier and full x64 build**

```powershell
pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1
msbuild MagicalGirlWand.slnx /restore /m /p:Platform=x64 /p:Configuration=Release /p:GeneratePackageLocally=true
```

Expected: both exit `0`; an installable package is generated under the CmdPal app package output.

- [ ] **Step 2: Run all retained unit tests**

Build test projects first, then run the produced assemblies through `vstest.console.exe`. Record test assembly count, passed, failed, and skipped totals. Do not report UI tests as passing unless WinAppDriver and Developer Mode are available and the tests actually execute.

- [ ] **Step 3: Install the generated package**

Install the generated `.msix`/`.msixbundle` and its certificate or use the generated `Add-AppDevPackage.ps1` from the package directory. Confirm with:

```powershell
Get-AppxPackage -Name '*MagicalGirlWand*' | Select-Object Name, Version, InstallLocation
```

Expected: exactly one current MagicalGirlWand package is installed.

- [ ] **Step 4: Run runtime smoke tests**

Verify:

1. App starts and is single-instance.
2. `Alt + Space` shows/hides the palette.
3. Settings can record and apply a different shortcut.
4. Home, nested pages, details, Markdown/form/grid samples, context menus, Dock, and representative built-in extensions render.
5. Everything top-level command returns file and directory results.
6. Everything fallback handles zero, one, and multiple results.
7. Stopping Everything produces a visible error and restores Indexer fallback without crashing.
8. Restarting Everything restores the Everything fallback.

- [ ] **Step 5: Document reproducible build/install instructions**

Update `README.md` and `docs/build/install-and-smoke-test.md` with exact commands and observed package paths. Include Everything prerequisites and fallback behavior.

- [ ] **Step 6: Commit and push**

```powershell
git add README.md docs/build
git commit -m "docs: add standalone build and install guide"
git push
```

## Task 12: Final completion audit

**Files:**
- Read: `docs/superpowers/specs/2026-06-24-cmdpal-standalone-fork-design.md`
- Read: this plan
- Read: current Git diff, build/test logs, installed package state

- [ ] **Step 1: Audit every design acceptance criterion**

Create a requirement-to-evidence table covering all nine acceptance criteria. Each row must cite a current file, command output, test result, installed package record, or runtime observation. Missing evidence is incomplete work.

- [ ] **Step 2: Verify the branch is clean and synchronized**

```powershell
git status --short --branch
git rev-parse HEAD
git rev-parse origin/cmdpal-standalone
```

Expected: clean status and matching local/remote commits.

- [ ] **Step 3: Run final verifier, Release build, tests, and installed-app smoke test**

Use fresh commands from Task 11. Do not reuse earlier logs as final evidence.

- [ ] **Step 4: Fix any audit gap and push the fix**

Every fix gets its own test, commit, and `git push`. Repeat the audit until no requirement is missing or contradicted.

- [ ] **Step 5: Mark the active goal complete only after all evidence passes**

Call the goal completion mechanism only after the clean-clone build, retained tests, package installation, Everything scenarios, and remote synchronization are all proven.

