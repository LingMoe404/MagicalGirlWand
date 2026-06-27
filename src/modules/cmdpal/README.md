# Command Palette

CmdPal 是 MagicalGirlWand 中的独立启动器。

当前内容包括：

- 默认使用 `Alt+Space` 召唤的启动器。
- 扩展画廊。
- `Create extension` 创建扩展流程。
- 扩展 SDK 和示例扩展。
- MagicalGirlWand 品牌资源与相关设置。

## 开发 CmdPal

- 修改主应用时，构建并运行 `Microsoft.CmdPal.UI`。
- 修改扩展接口时，构建 `Microsoft.CommandPalette.Extensions`。
- 修改 C# 辅助层时，构建 `Microsoft.CommandPalette.Extensions.Toolkit`。
- 检查扩展行为时，使用 `src\modules\cmdpal\ext\SamplePagesExtension` 下的示例扩展。

## 注意

CmdPal 仍在独立化整理中。保持改动小而明确；修改后验证对应 solution 或 solution filter；不要重新引入只属于 PowerToys 其他工具的路径或文档。
