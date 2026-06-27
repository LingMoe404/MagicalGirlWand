# ✨ 魔法少女魔杖 (MagicalGirlWand) - Windows Edition

![Version](https://img.shields.io/badge/version-0.11-FB7299?style=for-the-badge)
![AI Co-developed](https://img.shields.io/badge/AI_Co--developed-Codex_%7C_GPT_%7C_Antigravity_%7C_Gemini-8E75B2?style=for-the-badge)
![Platform](https://img.shields.io/badge/OS-Windows_10_%7C_11-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

> **“把 Command Palette 从 PowerToys 里抽出来，变成一支只负责召唤命令的魔杖。”**
>
> MagicalGirlWand 是从 Microsoft PowerToys CmdPal 拆分出的独立 Windows 命令面板仓库。它保留 CmdPal 启动器、扩展画廊、扩展 SDK、创建扩展流程与样例扩展，把仍然属于 PowerToys 全家桶的文档和模块说明逐步剥离。<br>
> 目标很明确：只维护这个独立 CmdPal 真正需要的代码、资源、构建脚本和开发说明。<br>
> *Built with C#, C++, WinUI / Windows App SDK and MSBuild · AI-assisted with Codex, GPT, Antigravity & Gemini.*

---

## 核心功能

* **快速召唤**：默认使用 `Alt+Space` 打开 CmdPal，集中搜索、执行命令与进入扩展页面。
* **扩展画廊**：保留 CmdPal 的扩展发现、展示与安装入口，方便把常用能力接入命令面板。
* **扩展 SDK / Toolkit**：`src/modules/cmdpal/extensionsdk/` 提供扩展开发所需接口与工具库。
* **创建扩展流程**：保留 `Create extension` 命令与 `ExtensionTemplate` 模板，方便从 CmdPal 内直接生成扩展项目。
* **内置扩展集合**：保留 Apps、Shell、System、Web Search、Windows Settings、Windows Terminal、Clipboard History、Window Walker 等 CmdPal 扩展代码。
* **独立品牌资源**：包含 MagicalGirlWand 的应用名、图标、StoreLogo 与 CmdPal 相关品牌化配置。
* **独立仓库验证**：提供 `tools/cmdpal/Verify-CmdPalStandalone.ps1`，用于检查 CmdPal 独立化过程中不该残留的引用和文档入口。

## 当前边界

MagicalGirlWand 不是 PowerToys 全量发行版，也不会在 README 里继续介绍 FancyZones、Color Picker、Advanced Paste 等 PowerToys 工具。当前仓库仍保留一部分上游共享代码、设置模型与构建基础设施，是为了让 CmdPal 能继续编译、运行和测试；这些内容会按独立化需要继续收敛。

`docs/superpowers/` 和 `.claude/` 属于本地开发辅助内容，不作为仓库文档上传。

## 项目结构

| 路径 | 用途 |
| :--- | :--- |
| `src/modules/cmdpal/` | CmdPal 主体、UI、ViewModels、键盘服务、扩展、SDK、模板与测试 |
| `src/common/` | CmdPal 仍依赖的共享基础库、IPC、日志、设置与工具代码 |
| `src/settings-ui/` | 当前仍被 CmdPal 设置与快捷键模型引用的设置层代码 |
| `tools/build/` | 上游构建脚本与本仓库构建入口 |
| `tools/cmdpal/` | CmdPal 独立化检查脚本 |
| `installer/` | 仍保留的安装器工程与打包相关文件 |

## 系统要求

* **操作系统**：Windows 10 / Windows 11
* **开发环境**：Visual Studio 2022 17.4+ 或 Visual Studio 2026
* **构建工具链**：MSBuild、Windows SDK、.NET / WinUI / C++ 桌面开发组件
* **仓库初始化**：首次构建前需要初始化子模块

## 源码构建

1. 克隆仓库并初始化子模块：

   ```powershell
   git clone https://github.com/LingMoe404/MagicalGirlWand.git
   cd MagicalGirlWand
   git submodule update --init --recursive
   ```

2. 首次构建，或 NuGet 依赖尚未准备好时：

   ```powershell
   tools\build\build-essentials.cmd
   ```

3. 构建 Debug：

   ```powershell
   tools\build\build.ps1 -Platform x64 -Configuration Debug
   ```

4. 构建 Release：

   ```powershell
   tools\build\build.ps1 -Platform x64 -Configuration Release
   ```

## 开发与验证

改动 CmdPal 独立化、品牌资源、构建文件或根目录文档后，建议先运行：

```powershell
pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1
```

改动代码后先保证对应项目能构建成功，再运行相关测试。这个仓库继承了 PowerToys 的测试习惯：优先使用 Visual Studio Test Explorer 或 `vstest.console.exe`，不要直接用 `dotnet test` 作为默认验证方式。

## 关于作者

我是 **泠萌404**，一名喜欢折腾 Windows 工具、硬件、NAS 和 AI 协作开发的普通上班族。

| 平台 | ID / 频道 | 链接 |
| :--- | :--- | :--- |
| Bilibili | **泠萌404** | [点击跳转](https://space.bilibili.com/136850) |
| YouTube | **泠萌404** | [点击跳转](https://www.youtube.com/@LingMoe404) |
| Douyin | **泠萌404** | [点击跳转](https://www.douyin.com/user/MS4wLjABAAAA8fYebaVF2xlczanlTvT-bVoRxLqNjp5Tr01pV8wM88Q) |

## 致谢

本项目离不开以下开源项目、运行时与开发工具：

* [Microsoft PowerToys](https://github.com/microsoft/PowerToys)：CmdPal 的上游来源与基础架构。
* [Windows App SDK / WinUI](https://learn.microsoft.com/windows/apps/windows-app-sdk/)：桌面 UI 与 Windows 集成能力。
* [.NET](https://dotnet.microsoft.com/) 与 MSBuild：托管代码、项目系统与构建流程。
* **OpenAI Codex / GPT**：参与代码整理、调试、测试与文档重写。
* **Google Antigravity / Gemini**：参与方案探索、重构优化与开发辅助。

## 开发幕后

MagicalGirlWand 是一个由 **泠萌404 主导，AI 协作开发的 CmdPal 独立化项目**。泠萌404 负责产品方向、需求取舍、评审与最终决策；OpenAI Codex / GPT 与 Google Antigravity / Gemini 协作参与代码实现、仓库整理、验证与文档维护。

## 开源协议

本仓库沿用上游 Microsoft PowerToys 的 MIT License，详见 [LICENSE](LICENSE)。

Copyright © 2026 泠萌404
