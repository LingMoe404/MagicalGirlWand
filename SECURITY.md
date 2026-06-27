# Security Policy

MagicalGirlWand is not a Microsoft-owned repository and is not covered by the Microsoft Security Response Center process.

## Reporting a vulnerability

Please do not report security vulnerabilities through public GitHub issues.

Use GitHub's private vulnerability reporting feature for this repository when available. If that is not available, contact the maintainer through the public profile linked from the repository and share only the minimum information needed to establish a secure reporting channel.

Include as much of the following as you can:

- Affected version, branch, or commit.
- A short description of the vulnerability.
- Reproduction steps or proof-of-concept details.
- Impact and likely attacker requirements.
- Any logs, crash dumps, or screenshots that do not contain secrets.

## Scope

Security-sensitive areas include:

- CmdPal command execution, URI handling, and shell integration.
- Extension loading, extension gallery metadata, and install/update flows.
- Installer, elevation, startup, and policy-related code.
- File, clipboard, environment, and process access from built-in extensions.
- Any code handling secrets, tokens, local paths, or user-provided input.

## Out of scope

- Vulnerabilities in upstream Microsoft PowerToys releases should be reported to Microsoft instead.
- Bugs in third-party tools or extensions should be reported to their maintainers unless MagicalGirlWand changes the behavior.
- Public feature requests, build failures, and non-sensitive bugs can use regular GitHub issues.

## Disclosure

Give maintainers reasonable time to investigate and prepare a fix before public disclosure. Do not publish exploit details while a fix is still being coordinated.
