function Get-SolutionFilterProjects {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $FilterPath,

        [Parameter(Mandatory)]
        [string] $RepoRoot
    )

    $filter = Get-Content -Raw -LiteralPath $FilterPath | ConvertFrom-Json
    foreach ($project in $filter.solution.projects) {
        [IO.Path]::GetFullPath((Join-Path $RepoRoot $project))
    }
}

function Get-ProjectReferences {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $ProjectPath
    )

    [xml] $projectXml = Get-Content -Raw -LiteralPath $ProjectPath
    $projectDirectory = Split-Path -Parent $ProjectPath

    foreach ($node in $projectXml.SelectNodes("//*[local-name()='ProjectReference'][@Include]")) {
        $include = $node.GetAttribute('Include')
        if ([string]::IsNullOrWhiteSpace($include) -or $include.Contains('$(')) {
            continue
        }

        [IO.Path]::GetFullPath((Join-Path $projectDirectory $include))
    }
}

function Get-MissingProjectDependencies {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]] $ProjectPaths
    )

    foreach ($project in $ProjectPaths) {
        if (-not (Test-Path -LiteralPath $project)) {
            "Missing project: $project"
            continue
        }

        foreach ($reference in Get-ProjectReferences -ProjectPath $project) {
            if (-not (Test-Path -LiteralPath $reference)) {
                "$project -> $reference"
            }
        }
    }
}

function Get-ProjectDependencyEntries {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $ProjectPath
    )

    [xml] $projectXml = Get-Content -Raw -LiteralPath $ProjectPath
    $projectDirectory = Split-Path -Parent $ProjectPath
    $dependencyAttributes = @{
        AdditionalFiles  = 'Include'
        AppxManifest     = 'Include'
        ClCompile        = 'Include'
        ClInclude        = 'Include'
        Compile          = 'Include'
        Content          = 'Include'
        EmbeddedResource = 'Include'
        Import           = 'Project'
        Midl             = 'Include'
        Natvis           = 'Include'
        None             = 'Include'
        ProjectReference = 'Include'
        Resource         = 'Include'
        ResourceCompile  = 'Include'
    }

    foreach ($node in $projectXml.SelectNodes('//*')) {
        $attributeName = $dependencyAttributes[$node.LocalName]
        if ([string]::IsNullOrEmpty($attributeName) -or -not $node.HasAttribute($attributeName)) {
            continue
        }

        $rawValue = $node.GetAttribute($attributeName)
        foreach ($value in $rawValue.Split(';', [StringSplitOptions]::RemoveEmptyEntries)) {
            $trimmedValue = $value.Trim()
            if ([string]::IsNullOrWhiteSpace($trimmedValue)) {
                continue
            }

            if ($trimmedValue -match '\$\(|%\(|@\(') {
                [pscustomobject]@{
                    ProjectPath = $ProjectPath
                    Kind        = $node.LocalName
                    RawValue    = $trimmedValue
                    FullPath    = $null
                    IsResolved  = $false
                    Exists      = $false
                }
                continue
            }

            $fullPath = if ([IO.Path]::IsPathRooted($trimmedValue)) {
                [IO.Path]::GetFullPath($trimmedValue)
            }
            else {
                [IO.Path]::GetFullPath((Join-Path $projectDirectory $trimmedValue))
            }

            if ($trimmedValue.IndexOfAny([char[]]@('*', '?')) -ge 0) {
                $matches = @(Get-ChildItem -Path $fullPath -File -ErrorAction SilentlyContinue)
                if ($matches.Count -gt 0) {
                    foreach ($match in $matches) {
                        [pscustomobject]@{
                            ProjectPath = $ProjectPath
                            Kind        = $node.LocalName
                            RawValue    = $trimmedValue
                            FullPath    = $match.FullName
                            IsResolved  = $true
                            Exists      = $true
                        }
                    }
                }
                else {
                    [pscustomobject]@{
                        ProjectPath = $ProjectPath
                        Kind        = $node.LocalName
                        RawValue    = $trimmedValue
                        FullPath    = $fullPath
                        IsResolved  = $true
                        Exists      = $false
                    }
                }
                continue
            }

            [pscustomobject]@{
                ProjectPath = $ProjectPath
                Kind        = $node.LocalName
                RawValue    = $trimmedValue
                FullPath    = $fullPath
                IsResolved  = $true
                Exists      = Test-Path -LiteralPath $fullPath
            }
        }
    }
}

function Get-ProjectReferenceClosure {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]] $ProjectPaths
    )

    $seen = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    $pending = [Collections.Generic.Queue[string]]::new()

    foreach ($project in $ProjectPaths) {
        $pending.Enqueue([IO.Path]::GetFullPath($project))
    }

    while ($pending.Count -gt 0) {
        $project = $pending.Dequeue()
        if (-not $seen.Add($project)) {
            continue
        }

        if (-not (Test-Path -LiteralPath $project)) {
            continue
        }

        foreach ($reference in Get-ProjectReferences -ProjectPath $project) {
            if (-not $seen.Contains($reference)) {
                $pending.Enqueue($reference)
            }
        }
    }

    $seen | Sort-Object
}

function Get-ResolvedCmdPalDependencies {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]] $ProjectPaths
    )

    $resolved = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($project in $ProjectPaths) {
        $fullProjectPath = [IO.Path]::GetFullPath($project)
        if (-not (Test-Path -LiteralPath $fullProjectPath)) {
            continue
        }

        $resolved.Add($fullProjectPath) | Out-Null
        foreach ($entry in Get-ProjectDependencyEntries -ProjectPath $fullProjectPath) {
            if ($entry.IsResolved -and $entry.Exists) {
                $resolved.Add($entry.FullPath) | Out-Null
            }
        }
    }

    $resolved | Sort-Object
}

function Get-UnresolvedCmdPalDependencies {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]] $ProjectPaths
    )

    foreach ($project in $ProjectPaths) {
        $fullProjectPath = [IO.Path]::GetFullPath($project)
        if (-not (Test-Path -LiteralPath $fullProjectPath)) {
            continue
        }

        Get-ProjectDependencyEntries -ProjectPath $fullProjectPath |
            Where-Object { -not $_.IsResolved }
    }
}

function Resolve-NativeIncludeDirectory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Value,

        [Parameter(Mandatory)]
        [string] $ProjectDirectory,

        [Parameter(Mandatory)]
        [string] $RepoRoot
    )

    $trimmedValue = $Value.Trim()
    if ([string]::IsNullOrWhiteSpace($trimmedValue) -or $trimmedValue -match '^%\(') {
        return $null
    }

    $resolvedValue = $trimmedValue.
        Replace('$(RepoRoot)', ([IO.Path]::GetFullPath($RepoRoot).TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar)).
        Replace('$(SolutionDir)', ([IO.Path]::GetFullPath($RepoRoot).TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar))

    if ($resolvedValue -match '\$\(|%\(|@\(') {
        return $null
    }

    if ([IO.Path]::IsPathRooted($resolvedValue)) {
        [IO.Path]::GetFullPath($resolvedValue)
    }
    else {
        [IO.Path]::GetFullPath((Join-Path $ProjectDirectory $resolvedValue))
    }
}

function Get-NativeIncludeDirectories {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [xml] $ProjectXml,

        [Parameter(Mandatory)]
        [string] $ProjectDirectory,

        [Parameter(Mandatory)]
        [string] $RepoRoot
    )

    $directories = [Collections.Generic.List[string]]::new()
    $directories.Add([IO.Path]::GetFullPath($ProjectDirectory))

    foreach ($node in $ProjectXml.SelectNodes("//*[local-name()='AdditionalIncludeDirectories']")) {
        foreach ($rawDirectory in $node.InnerText.Split(';', [StringSplitOptions]::RemoveEmptyEntries)) {
            $directory = Resolve-NativeIncludeDirectory -Value $rawDirectory -ProjectDirectory $ProjectDirectory -RepoRoot $RepoRoot
            if (-not [string]::IsNullOrWhiteSpace($directory)) {
                $directories.Add($directory)
            }
        }
    }

    $directories | Sort-Object -Unique
}

function Get-NativeSourceFiles {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [xml] $ProjectXml,

        [Parameter(Mandatory)]
        [string] $ProjectDirectory
    )

    foreach ($node in $ProjectXml.SelectNodes("//*[local-name()='ClCompile'][@Include]")) {
        $include = $node.GetAttribute('Include')
        if ([string]::IsNullOrWhiteSpace($include) -or $include -match '\$\(|%\(|@\(') {
            continue
        }

        $sourcePath = if ([IO.Path]::IsPathRooted($include)) {
            [IO.Path]::GetFullPath($include)
        }
        else {
            [IO.Path]::GetFullPath((Join-Path $ProjectDirectory $include))
        }

        if (Test-Path -LiteralPath $sourcePath) {
            $sourcePath
        }
    }
}

function Test-PathWithinRoot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Root
    )

    $fullPath = [IO.Path]::GetFullPath($Path)
    $fullRoot = [IO.Path]::GetFullPath($Root).TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
    $rootPrefix = $fullRoot + [IO.Path]::DirectorySeparatorChar

    $fullPath.Equals($fullRoot, [StringComparison]::OrdinalIgnoreCase) -or
        $fullPath.StartsWith($rootPrefix, [StringComparison]::OrdinalIgnoreCase)
}

function Get-NativeIncludeDependencyEntries {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]] $ProjectPaths,

        [Parameter(Mandatory)]
        [string] $RepoRoot
    )

    $repoRootPath = [IO.Path]::GetFullPath($RepoRoot)
    $includePattern = '^\s*#\s*include\s*[<"]([^>"]+)[>"]'
    $externalIncludeRoots = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    @('winrt', 'wil', 'gsl', 'spdlog') | ForEach-Object { $externalIncludeRoots.Add($_) | Out-Null }

    foreach ($project in $ProjectPaths) {
        $projectPath = [IO.Path]::GetFullPath($project)
        if (-not (Test-Path -LiteralPath $projectPath) -or [IO.Path]::GetExtension($projectPath) -ne '.vcxproj') {
            continue
        }

        [xml] $projectXml = Get-Content -Raw -LiteralPath $projectPath
        $projectDirectory = Split-Path -Parent $projectPath
        $includeDirectories = @(Get-NativeIncludeDirectories -ProjectXml $projectXml -ProjectDirectory $projectDirectory -RepoRoot $repoRootPath)
        $sourceFiles = @(Get-NativeSourceFiles -ProjectXml $projectXml -ProjectDirectory $projectDirectory)

        foreach ($sourceFile in $sourceFiles) {
            $sourceDirectory = Split-Path -Parent $sourceFile
            $searchDirectories = @($sourceDirectory) + $includeDirectories | Sort-Object -Unique

            foreach ($line in Get-Content -LiteralPath $sourceFile) {
                if ($line -notmatch $includePattern) {
                    continue
                }

                $include = $Matches[1].Replace('\', '/')
                $includeRoot = ($include -split '/')[0]
                $candidatePaths = @($searchDirectories | ForEach-Object {
                        [IO.Path]::GetFullPath((Join-Path $_ $include))
                    })
                $existingPath = $candidatePaths | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
                $repoCandidatePaths = @($candidatePaths | Where-Object { Test-PathWithinRoot -Path $_ -Root $repoRootPath })
                $isRepoLocal = -not [string]::IsNullOrWhiteSpace($existingPath) -and (Test-PathWithinRoot -Path $existingPath -Root $repoRootPath)
                $isRepoLocal = $isRepoLocal -or ($include -match '[\\/]+' -and $repoCandidatePaths.Count -gt 0 -and -not $externalIncludeRoots.Contains($includeRoot))

                [pscustomobject]@{
                    ProjectPath   = $projectPath
                    SourcePath    = $sourceFile
                    Include       = $include
                    FullPath      = $existingPath
                    CandidatePath = $repoCandidatePaths | Select-Object -First 1
                    IsRepoLocal   = $isRepoLocal
                    Exists        = -not [string]::IsNullOrWhiteSpace($existingPath)
                }
            }
        }
    }
}

function Get-MissingNativeIncludeDependencies {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]] $ProjectPaths,

        [Parameter(Mandatory)]
        [string] $RepoRoot
    )

    Get-NativeIncludeDependencyEntries -ProjectPaths $ProjectPaths -RepoRoot $RepoRoot |
        Where-Object { $_.IsRepoLocal -and -not $_.Exists } |
        ForEach-Object {
            "$($_.ProjectPath) -> $($_.SourcePath) includes missing repo-local header $($_.Include)"
        } |
        Sort-Object -Unique
}

function New-CmdPalStandaloneSolution {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $RepoRoot,

        [Parameter(Mandatory)]
        [string[]] $ProjectPaths,

        [Parameter(Mandatory)]
        [string] $OutputPath
    )

    $sourceSolutionPath = Join-Path $RepoRoot 'PowerToys.slnx'
    [xml] $sourceSolution = Get-Content -Raw -LiteralPath $sourceSolutionPath
    $sourceProjects = [Collections.Generic.Dictionary[string, System.Xml.XmlElement]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($sourceProject in $sourceSolution.SelectNodes("//*[local-name()='Project'][@Path]")) {
        $sourceProjects[$sourceProject.GetAttribute('Path').Replace('\', '/')] = $sourceProject
    }

    $document = [Xml.XmlDocument]::new()
    $solution = $document.CreateElement('Solution')
    $document.AppendChild($solution) | Out-Null

    $configurations = $document.CreateElement('Configurations')
    $solution.AppendChild($configurations) | Out-Null
    foreach ($platformName in @('ARM64', 'x64')) {
        $platform = $document.CreateElement('Platform')
        $platform.SetAttribute('Name', $platformName)
        $configurations.AppendChild($platform) | Out-Null
    }

    $cmdPalFolder = $document.CreateElement('Folder')
    $cmdPalFolder.SetAttribute('Name', '/CmdPal/')
    $solution.AppendChild($cmdPalFolder) | Out-Null

    $dependenciesFolder = $document.CreateElement('Folder')
    $dependenciesFolder.SetAttribute('Name', '/Dependencies/')
    $solution.AppendChild($dependenciesFolder) | Out-Null

    foreach ($projectPath in ($ProjectPaths | Sort-Object -Unique)) {
        $relativePath = [IO.Path]::GetRelativePath($RepoRoot, $projectPath).Replace('\', '/')
        if (-not $sourceProjects.ContainsKey($relativePath)) {
            throw "Project '$relativePath' is not represented in PowerToys.slnx."
        }

        $clone = $document.ImportNode($sourceProjects[$relativePath], $true)
        if ($relativePath.StartsWith('src/modules/cmdpal/', [StringComparison]::OrdinalIgnoreCase)) {
            $cmdPalFolder.AppendChild($clone) | Out-Null
        }
        else {
            $dependenciesFolder.AppendChild($clone) | Out-Null
        }
    }

    $settings = [Xml.XmlWriterSettings]::new()
    $settings.Encoding = [Text.UTF8Encoding]::new($false)
    $settings.Indent = $true
    $settings.IndentChars = '  '
    $settings.NewLineChars = "`n"
    $settings.NewLineHandling = [Xml.NewLineHandling]::Replace
    $settings.OmitXmlDeclaration = $true

    $writer = [Xml.XmlWriter]::Create($OutputPath, $settings)
    try {
        $document.Save($writer)
    }
    finally {
        $writer.Dispose()
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    $repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
    $filterPath = Join-Path $repoRoot 'src\modules\cmdpal\CommandPalette.slnf'
    $filterProjects = @(Get-SolutionFilterProjects -FilterPath $filterPath -RepoRoot $repoRoot)
    $closure = @(Get-ProjectReferenceClosure -ProjectPaths $filterProjects)
    $closure | ForEach-Object { [IO.Path]::GetRelativePath($repoRoot, $_).Replace('\', '/') }
}
