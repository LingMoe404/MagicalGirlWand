# MagicalGirlWand Worktree Helper Scripts

This folder contains helper scripts to create and manage parallel Git worktrees for developing multiple changes without cloning the full repository each time.

## Why Worktrees?

Git worktrees let you have several checked-out branches sharing a single `.git` object store.

Benefits:

- Fast context switching without repeated clones.
- Lower disk usage than multiple full clones.
- Each change stays isolated in its own folder for independent builds and tests.
- Useful for parallel work such as a feature branch, a quick fix, and a documentation pass.

Recommended: keep active parallel worktrees to three or fewer per developer.

## Scripts

| Script | Purpose |
| --- | --- |
| `New-WorktreeFromFork.ps1/.cmd` | Create a worktree from a branch in a personal fork |
| `New-WorktreeFromBranch.ps1/.cmd` | Create or reuse a worktree for an existing local or remote branch |
| `New-WorktreeFromIssue.ps1/.cmd` | Start a new issue branch from a base branch, defaulting to `origin/main` |
| `Delete-Worktree.ps1/.cmd` | Remove a worktree and optionally its local branch or temporary remote |
| `WorktreeLib.ps1` | Shared helpers for naming, listing, upstream setup, and summary output |

## Typical Flows

### Create From a Fork Branch

```powershell
.\New-WorktreeFromFork.ps1 -Spec alice:feature/cmdpal-gallery
```

Creates a temporary remote, fetches that branch, creates a local branch, and places a new worktree beside the repo root.

### Create From an Existing Branch

```powershell
.\New-WorktreeFromBranch.ps1 -Branch origin/docs/readme-refresh
```

Fetches if needed and creates or reuses the worktree.

### Start a New Issue Branch

```powershell
.\New-WorktreeFromIssue.ps1 -Number 1234 -Title "CmdPal crashes on launch"
```

Creates `issue/1234-cmdpal-crashes-on-launch` from `origin/main` unless `-Base` is supplied.

### Delete a Worktree

```powershell
.\Delete-Worktree.ps1 -Pattern docs/readme-refresh
```

Add `-Force` only when you intentionally want to discard local changes.

## After Creating a Worktree

Inside the new worktree:

1. Run `tools\build\build-essentials.cmd` if dependencies are not ready.
2. Build only the relevant project or solution filter.
3. Run `pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1` for standalone graph changes.
4. Commit and push.
5. Delete the worktree when done.

## Naming and Locations

- Worktrees are created as sibling folders of the repo root, such as `MagicalGirlWand` and `MagicalGirlWand-ab12`.
- Fork-based branches get local names like `fork-<user>-<sanitized-branch>`.
- Issue branches use `issue/<number>` or `issue/<number>-<slug>`.

## Safety Notes

- Scripts avoid force-deleting unless `-Force` is passed.
- No network credentials are stored; scripts use the existing Git credential helper.
- Review a new fork remote URL before pushing.
- Avoid editing the same file across multiple worktrees at the same time.

Update this document when script parameters or expected flows change.
