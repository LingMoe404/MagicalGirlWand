---
description: 'MagicalGirlWand AI contributor guidance'
---

# MagicalGirlWand – Copilot Instructions

简要规则。完整说明见 [AGENTS.md](../AGENTS.md)。

## 项目范围

- 把本仓库视为 standalone CmdPal，不是完整 Microsoft PowerToys。
- 只写当前仓库真实存在的功能。
- 不要恢复已删除的上游文档，例如 `doc/devdocs/`、`doc/specs/`、`doc/dsc/`、`doc/gpo/README.md`。
- `docs/superpowers/` 和 `.claude/` 是本地辅助内容，不应提交。

## 面向人类的内容

- README、PR 描述、release notes、支持文档、贡献文档等内容中文优先。
- 人名、账号、人类 ID、项目名、库名和工具名保持原文，不要翻译或改写。
- 示例：保留 **泠萌404**、`LingMoe404`、`OpenAI Codex`、`Google Antigravity`、`Microsoft PowerToys`、`CmdPal`。

## 基本规则

- 一次只做一个逻辑改动。
- 行为变化要添加或更新测试。
- hot path 不加噪声日志。
- 保持 `tools/cmdpal/standalone-keep-roots.txt` 和真实 standalone graph 一致。

## 风格

- C#: `src/.editorconfig`、StyleCop.Analyzers。
- C++: `src/.clang-format`。
- XAML: 按现有 XAML formatting scripts 或 XamlStyler。

## 常用验证

- 仅文档改动：`git diff --check`。
- standalone 范围变化：`pwsh -NoProfile -File tools\cmdpal\Verify-CmdPalStandalone.ps1`。
- 构建当前 project 或 solution：使用 `tools\build\build.cmd` 或 `tools\build\build.ps1`。

## 组件说明

- [CmdPal retained settings library](instructions/runner-settings-ui.instructions.md)
- [Common libraries](instructions/common-libraries.instructions.md)

## 主要参考

- [README.md](../README.md)
- [CONTRIBUTING.md](../CONTRIBUTING.md)
- [AGENTS.md](../AGENTS.md)
