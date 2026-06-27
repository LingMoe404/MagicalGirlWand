# MagicalGirlWand 贡献指南

请保持改动小、聚焦、容易审查。这个仓库的目标是 standalone CmdPal，不是完整 Microsoft PowerToys 套件。

## 开始前

1. 先确认当前分支或最近提交里是否已经有同类改动。
2. 优先沿用现有代码风格、目录结构和工具链。
3. 修改 CmdPal 时，始终记住独立化目标：只保留这个项目仍然需要的文件、文档和资源。
4. 给人类用户看的文档中文优先；人名、账号、人类 ID、项目名和工具名保留原文。

## 开发时

- 一次只做一个逻辑改动。
- 不要回滚无关文件或别人的改动。
- 行为变化要补测试，或说明为什么无法补。
- 提交前先构建或验证受影响区域。
- 不要把 `.claude/`、`docs/superpowers/` 这类本地辅助目录提交进仓库。

## CmdPal 相关改动

- 保持 `tools\cmdpal\Verify-CmdPalStandalone.ps1` 通过。
- 让 `tools\cmdpal\standalone-keep-roots.txt` 和真实 standalone 依赖闭包一致。
- 不要重新引入已经删除的 PowerToys 官方文档入口。
- 不要把 FancyZones、Color Picker、Advanced Paste 等无关 PowerToys 工具写成 MagicalGirlWand 功能。

## Pull Request

- PR 需要保持原子性。
- 说明具体改了什么、为什么改。
- 列出你实际运行过的验证命令。
- 如果跳过构建或测试，直接说明原因。
