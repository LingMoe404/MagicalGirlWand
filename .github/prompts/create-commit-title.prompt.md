---
agent: 'agent'
description: 'Generate an 80-character git commit title for the local diff'
---

# Generate Commit Title

## Purpose
Provide a single-line, ready-to-paste git commit title (<= 80 characters) that reflects the most important local changes since `HEAD`.

## Input to collect
- Run exactly one command to view the local diff:
  ```@terminal
  git diff HEAD
  ```

## How to decide the title
1. From the diff, find the dominant area (e.g., `src/modules/cmdpal/**`, `tools/cmdpal/**`, `.github/**`, root docs) and the change type (bug fix, docs update, config tweak).
2. Draft an imperative, plain-ASCII title that:
   - Mentions the primary component when obvious (e.g., `CmdPal:` or `Docs:`)
   - Stays within 80 characters and has no trailing punctuation

## Final output
- Reply with only the commit title on a single line—no extra text.

## PR title convention (when asked)
Use Conventional Commits style:

`<type>(<scope>): <summary>`

**Allowed types**
- feat, fix, docs, refactor, perf, test, build, ci, chore

**Scope rules**
- Use a short MagicalGirlWand-focused scope (one word preferred). Common scopes:
  - Product: `cmdpal`, `extensions`, `gallery`, `sdk`, `template`
  - Infrastructure: `common`, `settings`, `docs`, `build`, `ci`, `installer`, `agents`
- If unclear, pick the closest module or subsystem; omit only if unavoidable

**Summary rules**
- Imperative, present tense (“add”, “update”, “remove”, “fix”)
- Keep it <= 72 characters when possible; be specific, avoid “misc changes”

**Examples**
- `feat(gallery): add extension install status filter`
- `fix(cmdpal): guard hotkey summon during startup`
- `docs(agents): document standalone validation`
- `build(installer): align MagicalGirlWand package name`
- `ci(build): cache x64 build artifacts`
