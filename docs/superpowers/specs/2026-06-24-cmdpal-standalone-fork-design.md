# MagicalGirlWand：独立 CmdPal Fork 设计

## 状态

- 日期：2026-06-24
- 状态：已由用户批准
- 上游仓库：`microsoft/PowerToys`
- 起始上游提交：`80f2b9b07d56b2a8d27d73663e9c79751df81595`
- 工作分支：`cmdpal-standalone`

## 背景

MagicalGirlWand 将从原有的独立 WinUI 启动器迁移为 PowerToys Command Palette（CmdPal）的独立 fork。旧实现已迁移到 `A:\Code\MagicalGirlWand-backup`，新仓库是 `microsoft/PowerToys` 的 GitHub fork，并配置 `microsoft/PowerToys` 为 `upstream`。

目标不是重新实现一个外观相似的启动器，而是完整保留 CmdPal 宿主、扩展 SDK、内置扩展、Dock、复杂页面、设置、示例和测试。在此基础上删除与 CmdPal 无关的 PowerToys 模块，完成 MagicalGirlWand 品牌化，并新增基于 Everything SDK 的文件搜索扩展。

## 目标

1. 从 PowerToys 源码中提取一个可独立恢复、构建、测试、安装和运行的 CmdPal 依赖闭包。
2. 完整保留 CmdPal 现有功能和扩展模型。
3. 将用户可见品牌改为 MagicalGirlWand，同时尽量保持内部项目名和命名空间稳定，以便同步上游。
4. 将 `Alt + Space` 设为默认唤醒快捷键，并允许用户在设置中修改。
5. 新增 Everything 内置扩展，为 CmdPal 提供动态文件搜索页面和首页 fallback。
6. 保持明确的上游来源、许可证信息和可审计的迁移历史。

## 非目标

1. 不迁移旧 MagicalGirlWand 的界面、搜索架构或本地设置。
2. 不在第一轮精简中重命名全部 `Microsoft.CmdPal.*` 项目或命名空间。
3. 不删除任何 CmdPal 功能来换取更快的首个构建。
4. 不额外承诺 PowerToys CmdPal 上游尚未支持的平台。
5. 不在建立原版 CmdPal 构建基线前删除 PowerToys 源码。

## 仓库与依赖边界

最终仓库保留以下内容：

- 完整的 `src/modules/cmdpal`：
  - CmdPal UI 与 ViewModel；
  - 扩展 SDK 与 C# Toolkit；
  - 所有内置扩展；
  - Dock、详情、表单、Markdown、网格等页面能力；
  - 示例扩展；
  - 单元测试与 UI 测试。
- `CommandPalette.slnf` 引用的 `src/common` 项目。
- `src/settings-ui/Settings.UI.Library`。
- 被保留项目通过 `ProjectReference`、MSBuild `Import`、生成脚本、资源路径或测试工具实际引用的其他文件。
- 必需的根级 MSBuild、NuGet、代码分析、版本和许可证文件。

最终仓库删除以下内容：

- 不属于 CmdPal 且不在传递依赖闭包内的 PowerToys 模块；
- 只服务于已删除模块的安装、测试、CI 或资源文件；
- 完整 `PowerToys.slnx` 中与 CmdPal 无关的项目入口。

新建 `MagicalGirlWand.slnx` 作为独立解决方案入口。依赖闭包以实际构建和项目图为准，不能只依据目录名称判断。

## 迁移顺序

### 阶段 1：建立上游基线

1. 在未修改上游源码的状态下恢复 `src/modules/cmdpal/CommandPalette.slnf`。
2. 首先验证 x64 Debug 构建和可运行包。
3. 运行 CmdPal 可用的单元测试与 UI 测试，记录因环境条件无法运行的项目及原因。
4. 记录构建工具、Visual Studio workloads、Windows SDK 和包源要求。

### 阶段 2：生成依赖闭包

1. 从 `CommandPalette.slnf` 的项目列表开始。
2. 递归收集 `ProjectReference`、`Import`、源文件链接、生成脚本、资源和测试依赖。
3. 生成保留清单和删除候选清单。
4. 将根级构建文件视为显式依赖，不假设其可被简化替代。

### 阶段 3：分批精简

1. 按模块批次删除不相关代码。
2. 每批删除后执行项目引用扫描、恢复、构建和相关测试。
3. 构建失败时只修复该批次造成的依赖断裂，不同时进行品牌化或 Everything 开发。
4. 每个可验证批次形成独立提交，便于定位和回退。

### 阶段 4：独立解决方案与品牌化

1. 创建 `MagicalGirlWand.slnx`。
2. 修改产品显示名、窗口标题、包显示名、安装资产和图标。
3. 创建独立包身份和应用数据目录。
4. 保留内部 `Microsoft.CmdPal.*` 项目名和命名空间。
5. 将默认快捷键改为 `Alt + Space`，保留设置页的快捷键修改能力。

### 阶段 5：Everything 扩展

在精简后的 CmdPal 基线稳定后新增 Everything 扩展，不把 Everything 开发与依赖删除混在同一提交中。

## CmdPal 功能保留策略

以下能力属于必须保留范围：

- 首页命令、fallback 命令与模糊匹配；
- 命令、列表页、动态列表页、内容页、详情、表单、Markdown 和网格页面；
- 上下文命令、参数、筛选、分页和状态消息；
- 外部扩展发现、WinRT/COM 通信和扩展生命周期；
- 扩展缓存、frozen provider 和延迟激活；
- Dock、Dock Band 和固定命令；
- CmdPal 设置与扩展设置；
- 当前内置扩展、示例扩展及其测试。

如果某项能力依赖 PowerToys 公共基础设施，则保留所需基础设施，而不是删除该能力。

## Everything 扩展架构

新增 `Microsoft.CmdPal.Ext.Everything`，遵循现有 Indexer 扩展的结构和 CmdPal SDK 约定。

### `EverythingCommandsProvider`

- 使用稳定的 provider ID。
- 提供一个首页命令，打开 Everything 动态列表页。
- 提供一个首页 fallback 项。
- 管理 Everything 可用状态，并与 Indexer fallback 协调。

### `EverythingPage : DynamicListPage`

- 接收宿主写入的 `SearchText`。
- 查询变化时取消旧查询并创建新的查询代次。
- 使用 Everything IPC 执行搜索。
- 将原始结果转换为 CmdPal `IListItem`。
- 支持文件、文件夹和全部结果筛选。
- 支持分页加载，并正确更新 `HasMoreItems`。
- 通过 `RaiseItemsChanged` 通知宿主。
- 为空查询、无结果、服务不可用和查询错误提供独立 `EmptyContent`。

### `FallbackEverythingItem`

- 首页普通查询触发 Everything 搜索。
- 直接路径或唯一结果可返回直接可执行命令。
- 多个结果返回导航到预填查询的 `EverythingPage`。
- 查询更新必须取消前一次工作，过期结果不得修改当前项。

### `EverythingListItem`

每个结果至少提供：

- 文件名或文件夹名；
- 完整路径；
- 文件类型和合适的图标或缩略图；
- 默认打开命令；
- 复制路径；
- 打开所在目录；
- 对可执行文件提供管理员运行；
- 可由 CmdPal 详情区域消费的基础元数据。

### Indexer fallback 协调

- Windows Indexer 扩展完整保留。
- Everything 可用时，抑制重复的 Indexer 首页 fallback，避免同一文件查询出现两个入口。
- Everything 不可用时，恢复 Indexer fallback。
- Indexer 的首页命令和独立搜索页面始终保留。

## Everything 查询数据流

```text
SearchBox
  -> CmdPal ListViewModel
  -> IDynamicListPage.SearchText
  -> EverythingPage.UpdateSearchText
  -> cancel previous CancellationTokenSource
  -> Everything search adapter
  -> native Everything IPC
  -> map rows to EverythingListItem
  -> RaiseItemsChanged
  -> CmdPal fetches GetItems
  -> list UI update
```

所有异步查询都使用取消令牌和单调递增的查询代次。只有当前代次可以发布结果。图标和缩略图允许延迟加载，但同样必须检查取消状态。

## Everything 本地依赖

- Everything 原生库按 CmdPal 上游支持的平台分别打包。
- 原生调用封装在单一 adapter 后，页面与 fallback 不直接调用 P/Invoke。
- adapter 提供可替换接口，使测试不依赖本机 Everything 服务。
- DLL 缺失、架构不匹配、IPC 超时或 Everything 未运行均转换为可显示的错误状态。

## 错误处理

### 构建与精简错误

- 删除批次导致项目引用、Import、生成脚本或资源失效时，构建立刻失败。
- 不通过添加无关兼容层掩盖错误；恢复缺失的真实依赖或撤销该删除批次。
- `MagicalGirlWand.slnx` 不得引用仓库外路径。

### 扩展错误

- 单个扩展异常不得导致 CmdPal 宿主退出。
- Everything 查询异常转为状态消息或空状态，并记录诊断信息。
- 旧查询取消属于正常控制流，不显示为用户错误。
- Everything 不可用时启用 Indexer fallback。

### 配置错误

- 无效快捷键保留上一次有效配置并显示冲突提示。
- 新包身份使用全新的设置位置，不读取旧 MagicalGirlWand 设置文件。

## 品牌与上游同步

- 用户可见品牌统一为 MagicalGirlWand。
- 保留每个上游源码文件的 MIT 版权头和仓库许可证。
- 在项目文档中记录 PowerToys/CmdPal 来源和起始 commit。
- `origin` 指向 `LingMoe404/MagicalGirlWand`。
- `upstream` 指向 `microsoft/PowerToys`。
- 上游同步优先合并 CmdPal 和保留依赖范围内的变更；无关模块变更不进入独立解决方案。
- 避免无收益的大规模命名空间重写，以降低后续同步冲突。

## 测试策略

### 上游基线测试

- `CommandPalette.slnf` 恢复成功。
- x64 Debug 构建成功。
- 可生成并启动 CmdPal 包。
- 记录可执行的 CmdPal 单元测试和 UI 测试结果。

### 精简回归测试

- 每批删除后运行恢复和构建。
- 扫描指向不存在路径的 `ProjectReference`、`Import` 和资源引用。
- 运行受该批次影响的测试项目。
- 最终从干净克隆验证，不依赖本地未跟踪文件。

### Everything 单元测试

- 空查询不访问 IPC。
- 普通查询正确映射结果。
- 文件、文件夹筛选正确。
- 分页无重复和遗漏。
- 新查询取消旧查询。
- 旧查询晚返回不能覆盖新结果。
- 服务不可用产生可操作错误状态。
- Everything 不可用时恢复 Indexer fallback。
- 上下文命令生成正确的目标和参数。

### 集成与冒烟测试

- 应用单实例运行。
- 默认 `Alt + Space` 唤醒应用。
- 设置修改快捷键后新快捷键生效。
- 首页、导航、设置、Dock 和代表性的内置扩展可用。
- Everything 首页命令打开动态页面。
- Everything fallback 能从首页查询进入结果或搜索页面。
- Everything 故障不影响其他 CmdPal 扩展。

## 验收标准

1. 干净克隆可以按文档恢复和构建 `MagicalGirlWand.slnx`。
2. 仓库中不存在与 CmdPal 无关且不在传递依赖闭包内的 PowerToys 模块。
3. CmdPal 宿主、SDK、内置扩展、Dock、复杂页面、设置、示例和测试均保留。
4. MagicalGirlWand 使用独立品牌、包身份和数据目录。
5. 默认快捷键为 `Alt + Space`，并可在设置中修改。
6. Everything 动态页面和 fallback 可用，支持取消、分页和错误状态。
7. Everything 不可用时 Indexer fallback 可用。
8. 所有在当前开发环境可执行的保留测试通过；无法执行的测试具有明确的环境说明。
9. `origin` 和 `upstream` 配置及上游来源文档正确。

## 实施边界

实施必须分为可独立验证的计划任务：上游基线、依赖闭包、分批精简、独立解决方案、品牌化、Everything adapter、Everything 页面、fallback 协调、测试与最终验证。任一任务失败时停止扩大改动范围，先恢复该任务的可验证状态。
