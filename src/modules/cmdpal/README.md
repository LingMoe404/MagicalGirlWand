# Command Palette

CmdPal is the standalone launcher in MagicalGirlWand.

It currently ships with:

- a launcher bound by default to `Win+Alt+Space`
- the extension gallery
- the create-extension command
- the extension SDK and sample extensions
- the branded MagicalGirlWand assets and settings

## Working on CmdPal

- Build and run `Microsoft.CmdPal.UI` for the main app.
- Build `Microsoft.CommandPalette.Extensions` if you are changing the extension interface.
- Build `Microsoft.CommandPalette.Extensions.Toolkit` if you are changing the C# helper layer.
- Use the sample extensions under `src\modules\cmdpal\ext\SamplePagesExtension` to check extension behavior.

## Notes

CmdPal is still a moving target. Keep changes small, verify the solution after edits, and avoid reintroducing upstream-only paths or docs.


