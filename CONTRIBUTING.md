# MagicalGirlWand contributor's guide

Keep changes small, scoped, and easy to review.

## Before you start

1. Check whether the work already exists in the current branch or a recent commit.
2. Prefer the current codebase patterns over introducing new ones.
3. For CmdPal changes, keep the standalone goal in mind: only preserve files, docs, and assets that are still needed.

## While working

- Make one logical change at a time.
- Do not revert unrelated edits.
- Build and verify the changed area before claiming success.
- Add or update tests when behavior changes.

## CmdPal work

- Keep `tools\cmdpal\Verify-CmdPalStandalone.ps1` green.
- Keep `tools\cmdpal\standalone-keep-roots.txt` aligned with the actual standalone closure.
- Avoid reintroducing upstream-only links or docs.

## Pull requests

- Keep the PR atomic.
- Describe the change in concrete terms.
- Include the commands you ran to verify it.
