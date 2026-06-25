[CmdletBinding()]
param(
    [string] $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
)

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'Get-CmdPalDependencyClosure.ps1')

$filter = Join-Path $RepoRoot 'src\modules\cmdpal\CommandPalette.slnf'
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

$resolvedDependencyCount = @(Get-ResolvedCmdPalDependencies -ProjectPaths $closureProjects).Count
$unresolvedDependencyCount = @(Get-UnresolvedCmdPalDependencies -ProjectPaths $closureProjects).Count
Write-Host "Verified $($projects.Count) filter projects, a $($expectedProjects.Count)-project standalone closure, $resolvedDependencyCount resolved dependencies, and $unresolvedDependencyCount preserved MSBuild-property dependencies."
