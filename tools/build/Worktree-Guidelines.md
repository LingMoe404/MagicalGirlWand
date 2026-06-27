# MagicalGirlWand Worktree 辅助脚本

本目录包含用于创建和管理 Git worktree 的脚本，方便并行处理多个改动，而不需要重复克隆整个仓库。

## 为什么用 worktree

Git worktree 允许多个工作目录共享同一个 `.git` object store。

优点：

- 切换上下文更快，不需要重复 clone。
- 比多个完整 clone 更省磁盘。
- 每个改动独立在自己的目录里，方便分别构建和测试。
- 适合并行处理 feature branch、quick fix、文档整理等不同任务。

建议每个开发者同时活跃的 worktree 不超过 3 个。

## 脚本

| 脚本 | 用途 |
| --- | --- |
| `New-WorktreeFromFork.ps1/.cmd` | 从个人 fork 的分支创建 worktree |
| `New-WorktreeFromBranch.ps1/.cmd` | 从已有本地或远端分支创建或复用 worktree |
| `New-WorktreeFromIssue.ps1/.cmd` | 从 base branch 新建 issue 分支，默认 base 为 `origin/main` |
| `Delete-Worktree.ps1/.cmd` | 删除 worktree，并可选删除本地分支或临时 remote |
| `WorktreeLib.ps1` | 命名、列表、upstream 设置和摘要输出的共享 helper |

## 常见流程

### 从 fork 分支创建

```powershell
.\New-WorktreeFromFork.ps1 -Spec alice:feature/cmdpal-gallery
```

脚本会创建临时 remote、拉取该分支、创建本地分支，并在仓库根目录旁边创建新的 worktree。

### 从已有分支创建

```powershell
.\New-WorktreeFromBranch.ps1 -Branch origin/docs/readme-refresh
```

脚本会按需 fetch，然后创建或复用 worktree。

### 从 issue 创建新分支

```powershell
.\New-WorktreeFromIssue.ps1 -Number 1234 -Title "CmdPal crashes on launch"
```

默认从 `origin/main` 创建 `issue/1234-cmdpal-crashes-on-launch`，除非显式传入 `-Base`。

### 删除 worktree

```powershell
.\Delete-Worktree.ps1 -Pattern docs/readme-refresh
```

只有在明确要丢弃本地改动时才使用 `-Force`。

## 创建后要做什么

进入新的 worktree 后：

1. 如果依赖还没准备好，运行 `tools\build\build-essentials.cmd`。
2. 只构建相关 project 或 solution filter。
3. 修改独立 CmdPal 依赖图时运行 `pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1`。
4. 提交并推送。
5. 工作完成后删除 worktree。

## 命名和位置

- worktree 会作为仓库根目录的同级目录创建，例如 `MagicalGirlWand` 和 `MagicalGirlWand-ab12`。
- fork 分支的本地名称形如 `fork-<user>-<sanitized-branch>`。
- issue 分支使用 `issue/<number>` 或 `issue/<number>-<slug>`。

## 安全注意

- 脚本不会强制删除，除非传入 `-Force`。
- 脚本不保存网络凭据，只使用现有 Git credential helper。
- 推送前请检查新 fork remote URL。
- 避免在多个 worktree 中同时编辑同一个文件，减少 merge 冲突。

脚本参数或预期流程改变时，请同步更新本文档。
