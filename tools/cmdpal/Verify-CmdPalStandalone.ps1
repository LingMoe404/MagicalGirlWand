[CmdletBinding()]
param(
    [string] $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
)

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'Get-CmdPalDependencyClosure.ps1')

$filter = Join-Path $RepoRoot 'src\modules\cmdpal\CommandPalette.slnf'
$filterJson = Get-Content -Raw -LiteralPath $filter | ConvertFrom-Json
if ($filterJson.solution.path.Replace('\', '/') -ne '../../../MagicalGirlWand.slnx') {
    throw "CommandPalette.slnf must target MagicalGirlWand.slnx; got '$($filterJson.solution.path)'."
}

$fullPowerToysSolutionPath = Join-Path $RepoRoot 'PowerToys.slnx'
if (Test-Path -LiteralPath $fullPowerToysSolutionPath) {
    throw "Standalone repository must not retain the full PowerToys solution entry point: $fullPowerToysSolutionPath"
}

$forbiddenStandaloneRoots = @(
    'installer',
    'src/ActionRunner',
    'src/Common.Dotnet.FuzzTest.props',
    'src/Monaco.props',
    'src/common/Common.Search',
    'src/common/Common.UI',
    'src/common/COMUtils',
    'src/common/Display',
    'src/common/FilePreviewCommon',
    'src/common/GPOWrapper',
    'src/common/GPOWrapperProjection',
    'src/common/hooks',
    'src/common/LanguageModelProvider',
    'src/common/monitor_utils.h',
    'src/common/notifications',
    'src/common/PowerToys.ModuleContracts',
    'src/common/sysinternals',
    'src/common/Themes',
    'src/common/UnitTests-CommonLib',
    'src/common/UnitTests-CommonUtils',
    'src/common/updating',
    'src/dsc',
    'src/gpo',
    'src/Monaco',
    'src/PackageIdentity',
    'src/runner',
    'src/settings-ui/PowerToys.Settings.slnf',
    'src/settings-ui/QuickAccess.UI',
    'src/settings-ui/Settings.UI',
    'src/settings-ui/Settings.UI.Controls',
    'src/settings-ui/Settings.UI.UnitTests',
    'src/settings-ui/Settings.UI.XamlIndexBuilder',
    'src/settings-ui/UITest-Settings',
    'src/Update'
)
$retainedForbiddenRoots = @($forbiddenStandaloneRoots | Where-Object {
        Test-Path -LiteralPath (Join-Path $RepoRoot $_)
    })
if ($retainedForbiddenRoots.Count -ne 0) {
    throw "Standalone repository retains unrelated PowerToys infrastructure roots: $($retainedForbiddenRoots -join ', ')"
}

$projects = @(Get-SolutionFilterProjects -FilterPath $filter -RepoRoot $RepoRoot)
if ($projects.Count -lt 50) {
    throw "Expected the CmdPal filter to contain at least 50 projects; got $($projects.Count)."
}

$missing = @(Get-MissingProjectDependencies -ProjectPaths $projects)
if ($missing.Count -ne 0) {
    $missing | ForEach-Object { Write-Error $_ }
    throw 'CmdPal project graph contains missing dependencies.'
}

$fixtureRoot = Join-Path ([IO.Path]::GetTempPath()) "cmdpal-closure-$([guid]::NewGuid().ToString('N'))"
try {
    New-Item -ItemType Directory -Path $fixtureRoot | Out-Null
    $fixtureProject = Join-Path $fixtureRoot 'Fixture.csproj'
    @'
<Project Sdk="Microsoft.NET.Sdk">
  <ItemGroup>
    <ProjectReference Include="Missing.csproj" />
  </ItemGroup>
</Project>
'@ | Set-Content -LiteralPath $fixtureProject -Encoding utf8NoBOM

    $fixtureMissing = @(Get-MissingProjectDependencies -ProjectPaths @($fixtureProject))
    if ($fixtureMissing.Count -ne 1 -or $fixtureMissing[0] -notmatch 'Missing\.csproj') {
        throw "Expected one missing fixture dependency; got: $($fixtureMissing -join ', ')"
    }

    $dependencyProject = Join-Path $fixtureRoot 'DependencyFixture.csproj'
    New-Item -ItemType Directory -Path (Join-Path $fixtureRoot 'build') | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $fixtureRoot 'Shared') | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $fixtureRoot 'Assets') | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $fixtureRoot 'Properties') | Out-Null
    @('build\custom.props', 'Shared\Shared.cs', 'Assets\icon.png', 'Properties\Resources.resx') |
        ForEach-Object { New-Item -ItemType File -Path (Join-Path $fixtureRoot $_) | Out-Null }

    @'
<Project Sdk="Microsoft.NET.Sdk">
  <Import Project="build\custom.props" />
  <ItemGroup>
    <Compile Include="Shared\Shared.cs" Link="Shared.cs" />
    <AdditionalFiles Include="$(RepoRoot)src\codeAnalysis\StyleCop.json" />
    <Content Include="Assets\*.png" />
    <EmbeddedResource Include="Properties\Resources.resx" />
  </ItemGroup>
</Project>
'@ | Set-Content -LiteralPath $dependencyProject -Encoding utf8NoBOM

    $entries = @(Get-ProjectDependencyEntries -ProjectPath $dependencyProject)
    $resolvedNames = @($entries | Where-Object IsResolved | ForEach-Object { Split-Path -Leaf $_.FullPath })
    foreach ($expectedName in @('custom.props', 'Shared.cs', 'icon.png', 'Resources.resx')) {
        if ($expectedName -notin $resolvedNames) {
            throw "Expected resolved dependency '$expectedName'; got: $($resolvedNames -join ', ')"
        }
    }

    $unresolved = @($entries | Where-Object { -not $_.IsResolved })
    if ($unresolved.Count -ne 1 -or $unresolved[0].RawValue -ne '$(RepoRoot)src\codeAnalysis\StyleCop.json') {
        throw "Expected the MSBuild-property dependency to remain unresolved; got: $($unresolved.RawValue -join ', ')"
    }

    $resolvedDependencies = @(Get-ResolvedCmdPalDependencies -ProjectPaths @($dependencyProject))
    foreach ($expectedPath in @(
            $dependencyProject,
            (Join-Path $fixtureRoot 'build\custom.props'),
            (Join-Path $fixtureRoot 'Shared\Shared.cs'),
            (Join-Path $fixtureRoot 'Assets\icon.png'),
            (Join-Path $fixtureRoot 'Properties\Resources.resx')
        )) {
        if ($expectedPath -notin $resolvedDependencies) {
            throw "Expected resolved dependency path '$expectedPath'."
        }
    }

    $unresolvedDependencies = @(Get-UnresolvedCmdPalDependencies -ProjectPaths @($dependencyProject))
    if ($unresolvedDependencies.Count -ne 1 -or $unresolvedDependencies[0].RawValue -ne '$(RepoRoot)src\codeAnalysis\StyleCop.json') {
        throw "Expected one preserved unresolved dependency; got: $($unresolvedDependencies.RawValue -join ', ')"
    }

    $nativeProject = Join-Path $fixtureRoot 'NativeFixture.vcxproj'
    New-Item -ItemType Directory -Path (Join-Path $fixtureRoot 'Includes\local') | Out-Null
    New-Item -ItemType File -Path (Join-Path $fixtureRoot 'Includes\local\native_header.h') | Out-Null
    @'
#include <local/native_header.h>
#include <interface/missing_powertoy_module_interface.h>
#include <vector>
'@ | Set-Content -LiteralPath (Join-Path $fixtureRoot 'native.cpp') -Encoding utf8NoBOM
    @'
<Project>
  <ItemDefinitionGroup>
    <ClCompile>
      <AdditionalIncludeDirectories>Includes;%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>
    </ClCompile>
  </ItemDefinitionGroup>
  <ItemGroup>
    <ClCompile Include="native.cpp" />
  </ItemGroup>
</Project>
'@ | Set-Content -LiteralPath $nativeProject -Encoding utf8NoBOM

    $nativeIncludes = @(Get-NativeIncludeDependencyEntries -ProjectPaths @($nativeProject) -RepoRoot $fixtureRoot)
    if ($nativeIncludes.Where({ $_.Include -eq 'local/native_header.h' -and $_.Exists }).Count -ne 1) {
        throw 'Expected native include dependency discovery to resolve local/native_header.h.'
    }

    $missingNativeIncludes = @(Get-MissingNativeIncludeDependencies -ProjectPaths @($nativeProject) -RepoRoot $fixtureRoot)
    if ($missingNativeIncludes.Count -ne 1 -or $missingNativeIncludes[0] -notmatch 'interface/missing_powertoy_module_interface\.h') {
        throw "Expected one missing native include; got: $($missingNativeIncludes -join ', ')"
    }

    $nestedRoot = Join-Path $fixtureRoot 'Nested'
    New-Item -ItemType Directory -Path $nestedRoot | Out-Null
    $rootProject = Join-Path $fixtureRoot 'Root.csproj'
    $childProject = Join-Path $nestedRoot 'Child.csproj'
    $grandchildProject = Join-Path $nestedRoot 'Grandchild.csproj'
    '<Project Sdk="Microsoft.NET.Sdk"><ItemGroup><ProjectReference Include="Nested\Child.csproj" /></ItemGroup></Project>' |
        Set-Content -LiteralPath $rootProject -Encoding utf8NoBOM
    '<Project Sdk="Microsoft.NET.Sdk"><ItemGroup><ProjectReference Include="Grandchild.csproj" /></ItemGroup></Project>' |
        Set-Content -LiteralPath $childProject -Encoding utf8NoBOM
    '<Project Sdk="Microsoft.NET.Sdk" />' |
        Set-Content -LiteralPath $grandchildProject -Encoding utf8NoBOM

    $closure = @(Get-ProjectReferenceClosure -ProjectPaths @($rootProject))
    if ($closure.Count -ne 3 -or $closure -notcontains $grandchildProject) {
        throw "Expected a three-project recursive closure; got: $($closure -join ', ')"
    }
}
finally {
    if (Test-Path -LiteralPath $fixtureRoot) {
        Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
    }
}

$closureProjects = @(Get-ProjectReferenceClosure -ProjectPaths $projects)
$dependencyEntries = @($closureProjects | ForEach-Object { Get-ProjectDependencyEntries -ProjectPath $_ })
$missingLiteralDependencies = @($dependencyEntries | Where-Object {
        $_.IsResolved -and -not $_.Exists -and $_.RawValue -notmatch '[*?]'
    })
if ($missingLiteralDependencies.Count -ne 0) {
    $missingLiteralDependencies | ForEach-Object {
        Write-Error "Missing $($_.Kind) dependency: $($_.ProjectPath) -> $($_.FullPath)"
    }
    throw 'CmdPal project graph contains missing literal file dependencies.'
}

$missingNativeIncludes = @(Get-MissingNativeIncludeDependencies -ProjectPaths $closureProjects -RepoRoot $RepoRoot)
if ($missingNativeIncludes.Count -ne 0) {
    $missingNativeIncludes | ForEach-Object { Write-Error $_ }
    throw 'CmdPal native project graph contains missing repo-local include dependencies.'
}

$solutionPath = Join-Path $RepoRoot 'MagicalGirlWand.slnx'
if (-not (Test-Path -LiteralPath $solutionPath)) {
    throw "Standalone solution does not exist: $solutionPath"
}

[xml] $solutionXml = Get-Content -Raw -LiteralPath $solutionPath
$solutionProjectNodes = @($solutionXml.SelectNodes("/*[local-name()='Solution']/*[local-name()='Folder']/*[local-name()='Project']"))
$solutionProjects = @($solutionProjectNodes | ForEach-Object {
        [IO.Path]::GetFullPath((Join-Path $RepoRoot $_.GetAttribute('Path')))
    })

$expectedProjects = @($closureProjects | Sort-Object -Unique)
$actualProjects = @($solutionProjects | Sort-Object -Unique)
$repoPrefix = [IO.Path]::GetFullPath($RepoRoot).TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
$outsideRepo = @($actualProjects | Where-Object {
        -not $_.StartsWith($repoPrefix, [StringComparison]::OrdinalIgnoreCase)
    })
if ($outsideRepo.Count -ne 0) {
    throw "Standalone solution references projects outside the repository: $($outsideRepo -join ', ')"
}

$missingFromSolution = @($expectedProjects | Where-Object { $_ -notin $actualProjects })
$extraInSolution = @($actualProjects | Where-Object { $_ -notin $expectedProjects })
if ($solutionProjects.Count -ne $expectedProjects.Count -or $missingFromSolution.Count -ne 0 -or $extraInSolution.Count -ne 0) {
    throw "Standalone solution project mismatch. Expected $($expectedProjects.Count), actual $($solutionProjects.Count), missing: $($missingFromSolution -join ', '), extra: $($extraInSolution -join ', ')"
}

$platforms = @($solutionXml.Solution.Configurations.Platform | ForEach-Object Name)
foreach ($platform in @('ARM64', 'x64')) {
    if ($platform -notin $platforms) {
        throw "Standalone solution is missing platform '$platform'."
    }
}

$keepManifestPath = Join-Path $RepoRoot 'tools\cmdpal\standalone-keep-roots.txt'
if (-not (Test-Path -LiteralPath $keepManifestPath)) {
    throw "Standalone keep manifest does not exist: $keepManifestPath"
}

$allowedRoots = @(Get-Content -LiteralPath $keepManifestPath |
    ForEach-Object { $_.Trim().Replace('\', '/') } |
    Where-Object { -not [string]::IsNullOrWhiteSpace($_) -and -not $_.StartsWith('#') } |
    ForEach-Object { $_.TrimEnd('/') } |
    Sort-Object -Unique)
if ($allowedRoots.Count -eq 0) {
    throw "Standalone keep manifest is empty: $keepManifestPath"
}

foreach ($root in $allowedRoots) {
    if (-not (Test-Path -LiteralPath (Join-Path $RepoRoot $root))) {
        throw "Standalone keep manifest references a missing path: $root"
    }
}

$nativeIncludeDependencies = @(Get-NativeIncludeDependencyEntries -ProjectPaths $closureProjects -RepoRoot $RepoRoot |
    Where-Object { $_.IsRepoLocal -and $_.Exists } |
    ForEach-Object { $_.FullPath })
$resolvedDependencies = @(
    Get-ResolvedCmdPalDependencies -ProjectPaths $closureProjects
    $nativeIncludeDependencies
) | Sort-Object -Unique
$outsideKeepManifest = @($resolvedDependencies | Where-Object {
        $relativePath = [IO.Path]::GetRelativePath($RepoRoot, $_).Replace('\', '/')
        -not ($allowedRoots | Where-Object {
                $relativePath -eq $_ -or $relativePath.StartsWith("$_/", [StringComparison]::OrdinalIgnoreCase)
            })
    })
if ($outsideKeepManifest.Count -ne 0) {
    $outsideKeepManifest | ForEach-Object {
        Write-Error "Dependency outside keep manifest: $([IO.Path]::GetRelativePath($RepoRoot, $_).Replace('\', '/'))"
    }
    throw 'Standalone keep manifest is incomplete.'
}

$retainedRoots = @($resolvedDependencies | ForEach-Object {
        $relativePath = [IO.Path]::GetRelativePath($RepoRoot, $_).Replace('\', '/')
        $allowedRoots | Where-Object {
            $relativePath -eq $_ -or $relativePath.StartsWith("$_/", [StringComparison]::OrdinalIgnoreCase)
        } | Select-Object -First 1
    } | Sort-Object -Unique)

$unresolvedDependencyCount = @(Get-UnresolvedCmdPalDependencies -ProjectPaths $closureProjects).Count
Write-Host "Verified $($projects.Count) filter projects, a $($expectedProjects.Count)-project standalone closure, $($resolvedDependencies.Count) resolved dependencies, and $unresolvedDependencyCount preserved MSBuild-property dependencies."
Write-Host "Retained roots used by the CmdPal closure: $($retainedRoots -join ', ')"
