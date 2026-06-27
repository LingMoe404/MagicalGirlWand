# MagicalGirlWand 数据与隐私

MagicalGirlWand 是聚焦 standalone CmdPal 的 fork，不是 Microsoft PowerToys 官方发行版。本仓库本身不运营额外的云端分析服务。

## 本地会保存什么

根据构建和运行方式，CmdPal 以及保留的上游设置代码可能会在本地保存：

- 应用设置和快捷键偏好。
- 扩展配置。
- 最近命令或页面导航状态。
- 开发、构建或故障排查过程中生成的日志和诊断文件。

这些内容主要用于本地应用行为和诊断。公开上传日志前，请先检查其中是否包含个人路径、用户名、机器名、token、命令文本或其他隐私数据。

## 诊断事件

保留的上游 telemetry 代码中可能仍存在 `Microsoft.PowerToys.*` 命名空间，尤其是 CmdPal 和共享组件相关事件。这些名称是继承自上游的实现细节，不代表本仓库是 Microsoft 官方 telemetry 端点。

MagicalGirlWand 文档只把 CmdPal 相关诊断行为视为当前范围：

| 范围 | 可能相关的事件 |
| --- | --- |
| Command Palette 启动与关闭 | CmdPal 进程启动、热键召唤、冷启动、关闭 |
| 命令与查询执行 | 查询耗时、命令执行结果、扩展调用 |
| 页面与 dock 行为 | 页面导航、URI 打开、dock 配置 |
| 扩展行为 | 扩展命令调用、成功或错误状态 |

如果 telemetry 行为发生变化，需要同步更新本文档，写清事件名、收集字段、隐私影响和用户是否可以关闭。

## 不应该写在这里的内容

不要把 Microsoft PowerToys 的完整诊断事件表复制到本仓库。MagicalGirlWand 不应把 FancyZones、Color Picker、Advanced Paste、Image Resizer、Keyboard Manager、Workspaces 等无关模块写成当前产品功能。

## issue 和附件

报告问题时：

- 优先提供最小复现步骤，不要默认上传大型诊断包。
- 上传日志前先移除 secrets 和个人数据。
- 避免公开文件路径、剪贴板内容、命令历史或扩展凭据。
- 安全敏感内容请使用私密漏洞报告渠道。

## 上游隐私文档

Microsoft PowerToys 官方隐私和诊断政策请参考上游 Microsoft PowerToys 项目。本文只描述 MagicalGirlWand 仓库的文档边界。
