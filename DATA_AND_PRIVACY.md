# MagicalGirlWand 数据与隐私

MagicalGirlWand 目前没有自己的账号系统、云同步或云端分析服务。本页说明这个项目与 CmdPal 相关的数据边界。

## 本地会保存什么

根据版本和运行方式，CmdPal 可能会在本地保存：

- 应用设置和快捷键偏好。
- 扩展配置。
- 最近命令或页面导航状态。
- 开发、构建或故障排查过程中生成的日志和诊断文件。

这些内容主要用于本地应用行为和诊断。公开上传日志前，请先检查其中是否包含个人路径、用户名、机器名、token、命令文本或其他隐私数据。

## 诊断事件

源码中可能仍存在 `Microsoft.PowerToys.*` telemetry 命名空间，尤其是 CmdPal 和共享组件相关事件。这些名称来自上游实现，不表示 MagicalGirlWand 提供 Microsoft 官方诊断服务。

MagicalGirlWand 文档只把 CmdPal 相关诊断行为视为当前范围：

| 范围 | 可能相关的事件 |
| --- | --- |
| Command Palette 启动与关闭 | CmdPal 进程启动、热键召唤、冷启动、关闭 |
| 命令与查询执行 | 查询耗时、命令执行结果、扩展调用 |
| 页面与 dock 行为 | 页面导航、URI 打开、dock 配置 |
| 扩展行为 | 扩展命令调用、成功或错误状态 |

如果 telemetry 行为发生变化，需要同步更新本文档，写清事件名、收集字段、隐私影响和用户是否可以关闭。

## issue 和附件

报告问题时：

- 优先提供最小复现步骤，不要默认上传大型诊断包。
- 上传日志前先移除 secrets 和个人数据。
- 避免公开文件路径、剪贴板内容、命令历史或扩展凭据。
- 安全敏感内容请使用私密漏洞报告渠道。

## PowerToys 官方版本

如果你使用的是 Microsoft PowerToys 官方发行版，请以 Microsoft PowerToys 的隐私和诊断政策为准。FancyZones、Color Picker、Advanced Paste、Image Resizer、Keyboard Manager、Workspaces 等工具不属于 MagicalGirlWand 的当前功能范围。
