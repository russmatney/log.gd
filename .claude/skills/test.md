---
name: test
description: Run all gdUnit4 tests for the Log.gd plugin
invocableByUser: true
---

# Test Skill

Run all tests for the Log.gd plugin using the gdUnit4 test framework.

## Steps

1. Check if `GODOT_BIN` environment variable is set
2. If not set, ask the user for the Godot binary path
3. Run the test script: `sh addons/gdUnit4/runtest.sh`
4. Show the test results to the user

## Important Notes

The test script requires either `GODOT_BIN` environment variable or `--godot_binary` argument.
