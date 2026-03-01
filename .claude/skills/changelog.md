---
name: changelog
description: Add an entry to the CHANGELOG.md file
invocableByUser: true
arguments:
  - <entry_type>
  - <description>
---

# Changelog Skill

Add an entry to the CHANGELOG.md file following the project's changelog format.

## Arguments

- `<entry_type>`: Type of change (Added, Changed, Deprecated, Removed, Fixed, Security)
- `<description>`: Description of the change

## Steps

1. Read the current CHANGELOG.md to understand the format
2. Check if there's an Unreleased section, if not create one
3. Add the new entry under the appropriate type in the Unreleased section
4. Format the entry following the existing style
5. Show the user what was added

## Entry Types

- **Added** - New features
- **Changed** - Changes in existing functionality
- **Deprecated** - Soon-to-be removed features
- **Removed** - Removed features
- **Fixed** - Bug fixes
- **Security** - Security vulnerability fixes

## Usage Examples

```
/changelog Added "Support for custom color themes"
/changelog Fixed "Memory leak in array formatting"
/changelog Changed "Improved performance of to_pretty() method"
```

## Format

Entries are typically added following the [Keep a Changelog](https://keepachangelog.com/) format.
