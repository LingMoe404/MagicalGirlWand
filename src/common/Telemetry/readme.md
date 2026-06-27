# Telemetry Trace Capture

This folder contains retained upstream telemetry infrastructure used by shared code. Some provider names and `.wprp` files may still use `PowerToys` naming because the implementation comes from Microsoft PowerToys.

For MagicalGirlWand user-facing privacy documentation, see [DATA_AND_PRIVACY.md](../../../DATA_AND_PRIVACY.md).

## Starting Trace Capture

To capture a trace with the retained provider profile:

```powershell
wpr.exe -start "PowerToys.wprp"
```

## Stopping Trace Capture

```powershell
wpr.exe -stop "Trace.etl"
```

## Viewing Events

Open `Trace.etl` in Windows Performance Analyzer.

## Notes

- Do not attach traces publicly before checking for personal paths, command text, usernames, or other private data.
- If provider names are renamed for MagicalGirlWand in code, update this file and [DATA_AND_PRIVACY.md](../../../DATA_AND_PRIVACY.md) together.

## Additional Resources

- [TraceLogging on Microsoft Learn](https://learn.microsoft.com/windows/win32/tracelogging/trace-logging-portal)
- [Recording and Viewing Events](https://learn.microsoft.com/windows/win32/tracelogging/tracelogging-record-and-display-tracelogging-events)
