# Step 3: Review and Grouping

Review each collected PR or commit and write a short release-note summary.

## Process

1. Inspect the diff for the PR or commit range.
2. Identify user-visible changes first.
3. Assign one release-note group from Step 2.
4. Mark internal-only cleanup as `Internal Cleanup`.
5. Skip noise such as formatting-only churn unless it affects release confidence.

## Summary Format

```csv
Number,Group,Title,Author,Summary,Validation
```

Write the grouped Markdown drafts under:

```text
Generated Files/ReleaseNotes/grouped-md/
```

Keep summaries project-specific. Do not describe unrelated PowerToys utilities as MagicalGirlWand features.
