# Command Palette

CmdPal 是 MagicalGirlWand 中的 standalone launcher。

当前保留的内容包括：

- 默认使用 `Alt+Space` 召唤的 launcher。
- extension gallery。
- `Create extension` 创建扩展流程。
- extension SDK 和 sample extensions。
- MagicalGirlWand 品牌资源与相关设置。

## 开发 CmdPal

- 修改主应用时，构建并运行 `Microsoft.CmdPal.UI`。
- 修改扩展接口时，构建 `Microsoft.CommandPalette.Extensions`。
- 修改 C# helper layer 时，构建 `Microsoft.CommandPalette.Extensions.Toolkit`。
- 检查扩展行为时，使用 `src\modules\cmdpal\ext\SamplePagesExtension` 下的 sample extensions。

## 注意

CmdPal 仍在独立化整理中。保持改动小而明确；修改后验证 solution；不要重新引入只属于上游 PowerToys 全量仓库的路径或文档。
