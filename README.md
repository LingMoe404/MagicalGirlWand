<p align="center">
  <img src="src/modules/cmdpal/Microsoft.CmdPal.UI/Assets/MagicalGirlWand/StoreLogo.png" width="128" alt="MagicalGirlWand logo" />
</p>

<h1 align="center">MagicalGirlWand</h1>

<p align="center">
  把 CmdPal 从 PowerToys 里拆出来，做成一个只保留自己该有东西的独立仓库。
</p>

<p align="center">
  <a href="#现在有什么">现在有什么</a>
  <span> · </span>
  <a href="#怎么跑">怎么跑</a>
  <span> · </span>
  <a href="#怎么改">怎么改</a>
  <span> · </span>
  <a href="#许可">许可</a>
</p>

## 现在有什么

- CmdPal 启动器，默认快捷键是 `Win+Alt+Space`
- 扩展画廊
- 扩展 SDK
- `Create extension` 创建扩展流程
- 示例扩展和样例页面
- MagicalGirlWand 的品牌、图标和设置

## 怎么跑

第一次构建，或者 NuGet 还没准备好时：

```powershell
tools\build\build-essentials.cmd
```

然后编译解决方案：

```powershell
tools\build\build.ps1 -Platform x64 -Configuration Debug
```

想做 Release：

```powershell
tools\build\build.ps1 -Platform x64 -Configuration Release
```

## 怎么改

- 改 CmdPal 行为前，先跑 `tools\cmdpal\Verify-CmdPalStandalone.ps1`
- 修改后先保证能 build，再提交
- 只保留这个仓库真的还会用到的文档、脚本和资源

## 许可

见 [LICENSE](LICENSE)。
