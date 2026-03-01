---
name: godot
description: Open the Godot editor for this project
invocableByUser: true
---

# Godot Editor Skill

Open the Godot editor for the Log.gd project.

## Steps

1. Check if `GODOT_BIN` environment variable is set
2. If not set, ask the user for the Godot binary path
3. Open Godot editor with: `$GODOT_BIN --path . --editor`
4. Run this in the background so the user can continue working

## Notes

This skill launches the Godot editor as a background process, allowing you to continue using Claude Code while the editor is open.
