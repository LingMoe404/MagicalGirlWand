# 文件搜索内置扩展查询说明 (File Search Built-in Extension)

## 构建搜索查询

### 查询处理约定

这个模块不会总是把用户查询原样传给 Windows Search。

对于简单的自由文本查询，它会扩展文件名匹配，让搜索更符合直觉。对于看起来已经是 AQS 或其他 Windows Search 语法的查询，它不会改写。

这个分支是有意设计的：模块希望改善普通文件名搜索，但不能破坏结构化 Windows Search 查询。

### 什么时候不改写

如果输入看起来是结构化查询，我们会直接传给 `ISearchQueryHelper.GenerateSQLFromUserQuery(...)`。

示例：

- `name:report`
- `kind:folder`
- `kind:folder AND report`
- `*report*`
- `C:\Users`
- `size>10MB`
- `(report)`

括号会被保守处理，因为它们可能是真实查询语法。

### broadening 是什么意思

对于简单自由文本输入，我们可能构建两个文件名限制：

- 对 `System.FileName` 的 literal `LIKE` 限制。
- 对 `System.ItemNameDisplay` 的 indexed `CONTAINS(...)` 限制。

两者用途不同：

- `LIKE` 保留原始文本字面含义。
- `CONTAINS` 提供更好的 indexed matching，并能规范化类似分隔符的标点。

primary query 可能同时使用两者。fallback query 只使用 `LIKE` 分支。

### 有意的不对称

broadening 是有意不对称的。

期望行为：

- `red` 应该能找到 `[red]`。
- `[red]` 应该基本保持字面匹配。

也就是说：

- 普通词会被 broadening。
- 被标点包裹的 literal 通常不会被规范化。
- token 内部的分隔符标点仍可能触发 broadening。

这是本模块最重要的设计规则。

### 分隔符标点与包裹标点

一些标点在文件名中更像分隔符。

示例：

- `foo-bar`
- `20220409-tontrager.xlsx`

用户通常期待这里可以 broadening，因为 `tontrager` 仍应找到 `20220409-tontrager.xlsx`。

另一些标点通常表示 literal 意图。

示例：

- `[red]`
- `{draft}`
- `<todo>`

这些通常应该停留在 literal filename path，而不是被规范化为裸词。

### 示例

| 用户输入 | 行为 |
| --- | --- |
| `red` | broad plain-text search；可以匹配 `random [red] search.txt` |
| `[red]` | literal filename match；不会额外 broadening 到普通 `red` |
| `foo-bar` | 保留 literal `foo-bar` 匹配，同时作为 separator-style term broadening |
| `term Kind:Folder` | broadening `term`，保留 `Kind:Folder` |
| `%` | 在 filename match 中作为 literal percent sign 处理 |
| `_` | 在 filename match 中作为 literal underscore 处理 |
| `(report)` | 不在本地改写，直接传给 Windows Search |

### 为什么需要 fallback

有些输入是有效的 literal filename search，但不适合 full-text search。

典型失败模式：

- `CONTAINS(...)` 分支返回 `QUERY_E_ALLNOISE`。
- 或者 primary query 无法产生有用 rowset。

当两个分支都存在时：

- primary query = `CONTAINS(...) OR LIKE ...`
- fallback query = only `LIKE ...`

fallback 的作用是让标点较多或噪声较高的输入仍然能得到有用的文件名匹配。
