# Step 4: Summarization

Create the final release notes.

## Structure

```markdown
# MagicalGirlWand v{{ReleaseVersion}}

## Highlights

- <Most important user-facing change>

## CmdPal

- <Change>

## Extensions

- <Change>

## Extension SDK

- <Change>

## Build and Installer

- <Change>

## Documentation

- <Change>

## Validation

- <Command or release validation note>
```

Omit empty sections. Use Chinese-first public copy unless the maintainer asks for English.

## Rules

- Keep the notes honest: only list features present in the current repository.
- Keep upstream attribution where relevant, but do not make the release sound like an official Microsoft PowerToys release.
- Mention breaking changes, migration notes, and known limitations before internal cleanup.
