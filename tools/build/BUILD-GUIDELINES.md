# 构建脚本快速指南

这些脚本用于在本地构建 MagicalGirlWand。它们会初始化 Visual Studio 开发环境、恢复依赖，并在失败时写出日志。

## 快速开始

在仓库根目录运行：

```powershell
tools\build\build-essentials.cmd
tools\build\build.ps1 -Platform x64 -Configuration Debug
```

如果只构建某个项目或 solution filter，先 `cd` 到包含 `.sln`、`.slnf`、`.csproj` 或 `.vcxproj` 的目录，再运行：

```powershell
tools\build\build.cmd
```

## 该用哪个脚本

| 脚本 | 用途 |
| --- | --- |
| `build-essentials.cmd` / `build-essentials.ps1` | 首次构建，或需要 NuGet restore / bootstrap 时使用 |
| `build.cmd` / `build.ps1` | 构建当前目录下的 solution 或 project |
| `build-installer.ps1` | 仅用于安装器或打包工作，使用前确认影响范围 |

## 常用命令

```powershell
# 恢复依赖 / bootstrap
tools\build\build-essentials.cmd

# 构建 Debug x64
tools\build\build.ps1 -Platform x64 -Configuration Debug

# 构建 Release x64
tools\build\build.ps1 -Platform x64 -Configuration Release

# 仅 restore
tools\build\build.ps1 -RestoreOnly
```

## 独立 CmdPal 验证

修改项目引用、保留依赖路径、构建脚本或仓库范围文档时，运行：

```powershell
pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1
```

这个脚本会验证 `MagicalGirlWand.slnx`、CmdPal solution filters 和依赖保留清单。

## 日志与排错

构建失败时，先看 solution 或 project 旁边生成的日志：

- `build.<configuration>.<platform>.errors.log`：只包含错误，优先查看。
- `build.<configuration>.<platform>.warnings.log`：只包含警告。
- `build.<configuration>.<platform>.all.log`：完整文本日志。
- `build.<configuration>.<platform>.trace.binlog`：可用 MSBuild Structured Log Viewer 打开。

脚本会先尝试 DevShell (`Microsoft.VisualStudio.DevShell.dll` / `Enter-VsDevShell`)，再回退到 `VsDevCmd.bat`。

如果找不到 Visual Studio，请使用 "Developer PowerShell for VS 2022" 或 "Developer PowerShell for VS"，或者确认 `Program Files (x86)\Microsoft Visual Studio\Installer` 下存在 `vswhere.exe`。

## 注意

- 需要时用 `-Platform x64|arm64` 显式指定平台。
- CMD wrapper 会把参数转发给对应 PowerShell 脚本。
- 不要假设本仓库仍然存在完整上游 PowerToys solution。
