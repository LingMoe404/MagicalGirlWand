# Telemetry trace 采集说明

本目录包含保留的上游 telemetry 基础设施，供共享代码使用。部分 provider name 和 `.wprp` 文件仍可能使用 `PowerToys` 命名，因为实现来源是 Microsoft PowerToys。

MagicalGirlWand 面向用户的数据与隐私说明见 [DATA_AND_PRIVACY.md](../../../DATA_AND_PRIVACY.md)。

## 开始采集 trace

使用保留的 provider profile 采集 trace：

```powershell
wpr.exe -start "PowerToys.wprp"
```

## 停止采集 trace

```powershell
wpr.exe -stop "Trace.etl"
```

## 查看事件

用 Windows Performance Analyzer 打开 `Trace.etl`。

## 注意

- 公开上传 trace 前，请先检查其中是否包含个人路径、命令文本、用户名或其他隐私数据。
- 如果代码中把 provider name 重命名为 MagicalGirlWand，请同步更新本文档和 [DATA_AND_PRIVACY.md](../../../DATA_AND_PRIVACY.md)。

## 参考资料

- [TraceLogging on Microsoft Learn](https://learn.microsoft.com/windows/win32/tracelogging/trace-logging-portal)
- [Recording and Viewing Events](https://learn.microsoft.com/windows/win32/tracelogging/tracelogging-record-and-display-tracelogging-events)
