# ✨ 魔法少女魔杖 (MagicalGirlWand) - Windows Edition

![Version](https://img.shields.io/badge/version-0.11-FB7299?style=for-the-badge)
![AI Co-developed](https://img.shields.io/badge/AI_Co--developed-Codex_%7C_GPT_%7C_Antigravity_%7C_Gemini-8E75B2?style=for-the-badge)
![Platform](https://img.shields.io/badge/OS-Windows_10_%7C_11-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

> **“把 Command Palette 从 PowerToys 里抽出来，变成一支专注召唤命令的魔杖。”**
>
> MagicalGirlWand 是基于 Microsoft PowerToys CmdPal 整理出来的独立 Windows 命令面板。它保留 CmdPal 的快速召唤、扩展画廊、内置扩展和扩展开发能力，让 Command Palette 可以作为独立项目继续维护。<br>
> 当前重点是把 CmdPal 做成更清晰的独立应用；源码里仍有一些必要的 PowerToys 共享组件，后续会按实际依赖继续收敛。<br>
> *使用 C#、C++、WinUI / Windows App SDK 和 MSBuild 构建 · OpenAI Codex / GPT 与 Google Antigravity / Gemini 协作开发。*

---

## 核心功能

* **快速召唤**：默认使用 `Alt+Space` 打开 CmdPal，集中搜索、执行命令与进入扩展页面。
* **命令面板体验**：在一个入口里访问应用、系统命令、网页搜索、终端、剪贴板历史和窗口切换等常用能力。
* **扩展画廊**：提供扩展发现、展示与安装入口，方便把更多能力接入命令面板。
* **内置扩展集合**：包含 Apps、Shell、System、Web Search、Windows Settings、Windows Terminal、Clipboard History、Window Walker 等 CmdPal 扩展代码。
* **扩展 SDK / Toolkit**：`src/modules/cmdpal/extensionsdk/` 提供扩展开发所需接口与工具库。
* **创建扩展流程**：通过 `Create extension` 命令与 `ExtensionTemplate` 模板，从 CmdPal 内直接生成扩展项目。

## 当前状态

MagicalGirlWand 只覆盖 CmdPal 及其运行、构建、测试和打包所需部分。FancyZones、Color Picker、Advanced Paste 等 PowerToys 工具不属于本项目的功能范围。

如果在源码中看到 `PowerToys` 命名、共享组件或历史路径，它们只是当前依赖的一部分，不等同于 MagicalGirlWand 的功能入口。

## 源码结构

| 路径 | 用途 |
| :--- | :--- |
| `src/modules/cmdpal/` | CmdPal 主体、UI、ViewModels、键盘服务、扩展、SDK、模板与测试 |
| `src/common/` | CmdPal 依赖的共享基础库、IPC、日志、设置与工具代码 |
| `src/settings-ui/` | CmdPal 设置与快捷键模型引用的设置层代码 |
| `tools/build/` | 构建脚本与项目构建入口 |
| `tools/cmdpal/` | CmdPal 依赖范围检查脚本 |
| `installer/` | 安装器工程与打包相关文件 |

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

改动项目引用、依赖保留清单、品牌资源、构建文件或仓库范围文档后，建议先运行：

```powershell
pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1
```

改动代码后先保证对应项目能构建成功，再运行相关测试。这个仓库沿用上游测试习惯：优先使用 Visual Studio Test Explorer 或 `vstest.console.exe`，不要把 `dotnet test` 作为默认验证方式。

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

## 开发协作

MagicalGirlWand 是一个由 **泠萌404 主导，AI 协作开发的 CmdPal 独立化项目**。泠萌404 负责产品方向、需求取舍、评审与最终决策；OpenAI Codex / GPT 与 Google Antigravity / Gemini 协作参与代码实现、仓库整理、验证与文档维护。

## 开源协议

本仓库沿用上游 Microsoft PowerToys 的 MIT License，详见 [LICENSE](LICENSE)。

Copyright © 2026 泠萌404
