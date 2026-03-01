---
name: run-example
description: Run the example scene to demonstrate Log.gd functionality
invocableByUser: true
---

# Run Example Skill

Run the Log.gd example scene (`src/ExampleScene.tscn`) in Godot.

## Steps

1. Check if `GODOT_BIN` environment variable is set
2. If not set, ask the user for the Godot binary path
3. Run the example scene: `$GODOT_BIN --path . res://src/ExampleScene.tscn`
4. This will open a window showing the Log.gd showcase with various logging examples

## What You'll See

The example scene demonstrates:
- Easy newlines showcase
- Log levels (DEBUG, INFO, WARN, ERROR)
- Color theming options
- Integers and floats formatting
- Vector pretty-printing
- String formatting
- Array display
- Dictionary formatting
- Object representation
- Various configuration options
