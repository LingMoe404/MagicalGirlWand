# Step 2: Labeling

Group changes by MagicalGirlWand product area.

## Preferred Groups

| Keywords / Paths | Group |
| --- | --- |
| `src/modules/cmdpal/Microsoft.CmdPal.UI`, shell, settings, hotkey | CmdPal |
| `src/modules/cmdpal/ext`, built-in extension names | Extensions |
| `extensionsdk`, Toolkit, ABI, WinRT contracts | Extension SDK |
| gallery, install source, winget status | Gallery |
| `ExtensionTemplate`, create extension | Extension Template |
| `tools/build`, `installer`, `.pipelines`, `.github/workflows` | Build and Installer |
| `README`, `AGENTS`, `SUPPORT`, `.github/prompts`, docs | Documentation |
| deletion, cleanup, standalone keep roots | Internal Cleanup |

If a PR spans multiple areas, assign the most user-visible group first and mention secondary impact in the summary.

Do not use full PowerToys product labels such as FancyZones, Advanced Paste, Color Picker, or PowerToys Run unless the change is explicitly about removing or retaining upstream dependency code.
