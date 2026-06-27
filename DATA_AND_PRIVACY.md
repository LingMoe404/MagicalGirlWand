# MagicalGirlWand Data & Privacy

MagicalGirlWand is a standalone CmdPal-focused fork. It is not the official Microsoft PowerToys distribution, and this repository does not operate a separate cloud service for collecting project analytics.

## What the project stores locally

Depending on how the app is built and run, CmdPal and retained upstream settings code may store local configuration such as:

- App settings and shortcut preferences.
- Extension configuration.
- Recent command or navigation state.
- Logs or diagnostic files produced during development, build, or troubleshooting.

These files are intended for local app behavior and diagnostics. Do not attach logs publicly until you have checked them for personal paths, usernames, machine names, tokens, command text, or other private data.

## Diagnostic events

The retained upstream telemetry code may still contain event names under the `Microsoft.PowerToys.*` namespace, especially for CmdPal and shared components. Those names are inherited implementation details and do not mean this repository is an official Microsoft telemetry endpoint.

For MagicalGirlWand documentation, only CmdPal-related diagnostic behavior is considered in scope:

| Area | Examples of potentially relevant events |
| --- | --- |
| Command Palette launch and dismissal | CmdPal process start, hotkey summon, cold launch, dismissal |
| Command and query execution | Query timing, command execution result, extension invocation |
| Page and dock behavior | Page navigation, URI open, dock configuration |
| Extension behavior | Extension command invocation and success/error status |

If telemetry behavior changes, update this document with the exact event names, collected fields, privacy impact, and whether users can disable the behavior.

## What not to document here

Do not copy the full Microsoft PowerToys diagnostic event table into this repository. MagicalGirlWand should not advertise or document unrelated modules such as FancyZones, Color Picker, Advanced Paste, Image Resizer, Keyboard Manager, or Workspaces as if they were part of this product.

## Issue reports and attachments

When reporting bugs:

- Prefer minimal reproduction steps over large diagnostic bundles.
- Remove secrets and personal data from logs before uploading.
- Avoid sharing private file paths, clipboard contents, command history, or extension-specific credentials.
- Use private vulnerability reporting for security-sensitive data.

## Upstream privacy documentation

For the official Microsoft PowerToys privacy policy and diagnostics, refer to the upstream Microsoft PowerToys project. This file only describes the MagicalGirlWand repository's intended documentation boundary.
