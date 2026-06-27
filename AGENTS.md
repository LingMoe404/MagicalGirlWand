---
description: 'MagicalGirlWand 顶层 AI 贡献指南，适用于独立 CmdPal 项目'
applyTo: '**'
---

# MagicalGirlWand - AI 贡献指南

MagicalGirlWand 是基于 Microsoft PowerToys CmdPal 整理出来的独立 Windows 命令面板项目。处理这个仓库时，把它当成 CmdPal 项目，而不是完整 PowerToys 工具箱。

改动要小、聚焦、容易审查。总结工作时引用准确路径，不要把无关 PowerToys 工具写成 MagicalGirlWand 的功能。

## 项目范围

当前产品面是 CmdPal，以及构建、运行、测试、打包和扩展它所需的代码。

| 区域 | 路径 | 说明 |
| --- | --- | --- |
| CmdPal 应用 | `src/modules/cmdpal/Microsoft.CmdPal.UI/` | WinUI 应用、外壳、设置、扩展画廊、品牌资源和用户可见体验 |
| CmdPal ViewModels | `src/modules/cmdpal/Microsoft.CmdPal.UI.ViewModels/` | 应用状态、命令、扩展画廊、设置和服务 wiring |
| 扩展接口 | `src/modules/cmdpal/extensionsdk/Microsoft.CommandPalette.Extensions/` | 原生扩展 ABI 与 WinRT contracts |
| 扩展 Toolkit | `src/modules/cmdpal/extensionsdk/Microsoft.CommandPalette.Extensions.Toolkit/` | 面向扩展作者的 C# 辅助层 |
| 内置扩展 | `src/modules/cmdpal/ext/` | Apps、Shell、System、Web Search、Windows Settings、Windows Terminal、Clipboard History、Window Walker 等 CmdPal 扩展 |
| 扩展模板 | `src/modules/cmdpal/ExtensionTemplate/` | `Create extension` 流程使用的模板 |
| CmdPal 测试 | `src/modules/cmdpal/Tests/` | CmdPal、扩展和 Toolkit 的单元测试与 UI 测试 |
| 共享依赖 | `src/common/`、`src/settings-ui/Settings.UI.Library/` | CmdPal 当前依赖的共享代码 |
| 构建脚本 | `tools/build/` | 构建 wrapper 与 MSBuild 环境初始化 |
| 独立范围检查 | `tools/cmdpal/` | CmdPal 依赖闭包和独立范围验证脚本 |

如果源码里还存在上游模块或 PowerToys 命名，先把它们视为实现依赖；除非用户明确要求，不要把它们扩展成产品功能。

## 当前产品事实

- 产品名：`MagicalGirlWand`
- 版本来源：`src/modules/cmdpal/custom.props`
- 代码中的默认 CmdPal 快捷键：`Alt+Space`
- 主 solution：`MagicalGirlWand.slnx`
- 根 README 风格：参考同属 MagicalGirl 系列的项目，中文优先，只写当前真实存在的功能。

## 文档边界

- 面向用户和贡献者的仓库内容中文优先。
- 人名、账号、ID、项目名、库名和工具名保持原文，不要翻译或改写，例如 `LingMoe404`、`OpenAI Codex`、`Google Antigravity`、`Microsoft PowerToys`、`CmdPal`。
- 不要恢复已删除的 PowerToys 开发文档，例如 `doc/devdocs/`、`doc/specs/`、`doc/dsc/`、`doc/gpo/README.md`。
- 不要添加指向不存在文档的 README 链接。
- 不要宣传不属于 MagicalGirlWand 产品面的 PowerToys 工具。
- `docs/superpowers/` 只在本地保留，不提交。
- `.claude/` 只在本地保留，不提交。
- 如果保留的上游文件里有过时 PowerToys 表述，只有在它影响当前任务时才更新；不要为了扫词而大范围改无关源码。

## 构建

### 前置条件

- Visual Studio 2022 17.4+ 或 Visual Studio 2026
- Windows 10 / Windows 11
- 首次构建前初始化 submodules：

```powershell
git submodule update --init --recursive
```

### 常用命令

| 任务 | 命令 |
| --- | --- |
| 首次构建 / NuGet restore | `tools\build\build-essentials.cmd` |
| 构建当前 solution 或 project 目录 | `tools\build\build.cmd` |
| 构建 Debug x64 | `tools\build\build.ps1 -Platform x64 -Configuration Debug` |
| 构建 Release x64 | `tools\build\build.ps1 -Platform x64 -Configuration Release` |
| 验证独立 CmdPal 依赖范围 | `pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1` |

### 构建纪律

1. 先构建，再运行测试或启动应用。
2. 优先使用 `tools/build/` 里的脚本，除非有明确理由直接调用 MSBuild。
3. 聚焦改动时，先进入包含相关 `.sln`、`.slnf`、`.csproj` 或 `.vcxproj` 的目录，再运行 `build.cmd`。
4. 退出码 `0` 表示成功；任何非零退出码都要当作失败处理。
5. 构建失败时先看对应的 `build.<configuration>.<platform>.errors.log`，再看 `.all.log` 或 `.binlog`。

## 测试

使用离改动最近的测试项目。

- Toolkit 改动：优先看 `src/modules/cmdpal/Tests/Microsoft.CommandPalette.Extensions.Toolkit.UnitTests/`。
- UI ViewModel 改动：优先看 `src/modules/cmdpal/Tests/Microsoft.CmdPal.UI.ViewModels.UnitTests/`。
- 扩展改动：在 `src/modules/cmdpal/Tests/` 下找对应扩展测试项目。
- UI 自动化改动可能需要已有 UI test setup 和构建好的 app package。

先构建相关测试项目。默认使用 Visual Studio Test Explorer 或 `vstest.console.exe`；不要把 `dotnet test` 当作本仓库默认测试方式。

## 独立范围验证

修改以下内容时运行验证脚本：

- `MagicalGirlWand.slnx`
- 任意 `src/modules/cmdpal/**/*.slnf`、`.csproj` 或 `.vcxproj`
- CmdPal 依赖的 `src/common/` 或 `src/settings-ui/Settings.UI.Library/`
- `tools/build/` 或 `tools/cmdpal/`
- 描述仓库范围或保留路径的根目录文档

命令：

```powershell
pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1
```

如果脚本提示缺少 keep root，只有在确认路径确实应该保留或确实已经移除后，才更新 `tools/cmdpal/standalone-keep-roots.txt`。

## 需要额外谨慎的区域

| 区域 | 风险 |
| --- | --- |
| `src/modules/cmdpal/extensionsdk/Microsoft.CommandPalette.Extensions/` | ABI 与 WinRT contract 兼容性 |
| `src/modules/cmdpal/extensionsdk/Microsoft.CommandPalette.Extensions.Toolkit/` | 扩展作者 API 行为与 package 兼容性 |
| `src/modules/cmdpal/Microsoft.CmdPal.UI/` | 用户可见行为、设置迁移、本地化和应用打包 |
| `src/modules/cmdpal/Microsoft.CmdPal.UI.ViewModels/` | 命令路由、扩展生命周期、画廊状态和设置持久化 |
| `src/common/` | 共享依赖改动会影响多个保留项目 |
| `installer/` | 打包与发布影响 |
| 提权、启动、policy 或 shell 集成代码 | 安全与 Windows 行为回归 |

涉及安全敏感行为、安装器行为、公开扩展 contract，或会把项目范围重新扩大到完整 PowerToys 的改动，先向用户确认。

## 不要做的事

- 不要因为旧链接存在就恢复已删除的 PowerToys 文档。
- 不要记录当前 MagicalGirlWand build 里不存在的功能。
- 不要新增第三方依赖而不更新 `NOTICE.md` 并说明原因。
- 不要在没有同步 producer 和 consumer 的情况下破坏 IPC、JSON 设置 contract 或扩展 contract。
- 不要在 hot path 添加噪声日志。
- 不要提交本地 AI 辅助文件或生成的计划笔记。

## 完成前检查

按改动风险选择验证：

- [ ] 仅文档：`git diff --check`
- [ ] 独立范围或保留路径变化：`pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1`
- [ ] 代码改动：成功构建受影响项目或 solution
- [ ] 行为改动：添加或更新针对性测试并运行
- [ ] 依赖改动：需要时更新 `NOTICE.md`
- [ ] 总结里写清实际改动路径和跳过的验证
