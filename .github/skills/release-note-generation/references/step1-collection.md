# Step 1: Collection

Collect merged changes for the target MagicalGirlWand release.

## Inputs

- `{{ReleaseVersion}}`
- `{{BaseRef}}`
- `{{HeadRef}}`

## Recommended Commands

```powershell
gh pr list --state merged --base main --limit 200 --json number,title,author,mergedAt,labels,url
git log --oneline {{BaseRef}}..{{HeadRef}}
```

If tags are available, prefer the tag range. If no previous tag exists, use the last release commit or ask the maintainer for the base commit.

## Output

Write collected data to:

```text
Generated Files/ReleaseNotes/collected-prs.json
Generated Files/ReleaseNotes/raw-commits.txt
```

Keep collection focused on this repository. Do not fetch Microsoft PowerToys milestone data for MagicalGirlWand release notes.
