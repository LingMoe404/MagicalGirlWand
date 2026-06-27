# 安全政策

MagicalGirlWand 不是 Microsoft 拥有的仓库，也不适用 Microsoft Security Response Center 流程。

## 报告漏洞

请不要通过公开 GitHub issue 披露安全漏洞。

如果本仓库启用了 GitHub private vulnerability reporting，请优先使用该功能。若不可用，请通过仓库维护者公开资料中的联系方式建立安全沟通渠道，并只分享建立沟通所需的最少信息。

请尽量提供：

- 受影响的版本、分支或 commit。
- 漏洞的简短说明。
- 复现步骤或 proof-of-concept。
- 影响范围和攻击者前提。
- 不包含 secrets 的日志、crash dump 或截图。

## 范围

安全敏感区域包括：

- CmdPal 命令执行、URI 处理和 shell 集成。
- 扩展加载、扩展画廊元数据、安装和更新流程。
- 安装器、提权、启动和 policy 相关代码。
- 内置扩展对文件、剪贴板、环境变量和进程的访问。
- 任何处理 secrets、tokens、本地路径或用户输入的代码。

## 不在本仓库处理的范围

- 上游 Microsoft PowerToys 官方发行版漏洞应报告给 Microsoft。
- 第三方工具或扩展自身漏洞应报告给对应维护者，除非 MagicalGirlWand 的改动改变了风险。
- 普通 bug、构建失败和非敏感功能请求可以使用公开 GitHub issue。

## 披露

公开披露前，请给维护者合理时间调查和准备修复。修复协调期间不要公开 exploit 细节。
