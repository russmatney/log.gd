---
name: test-file
description: Run tests for a specific test file
invocableByUser: true
arguments:
  - <test_file_path>
---

# Test File Skill

Run tests for a specific test file using gdUnit4.

## Arguments

- `<test_file_path>` (optional) - Path to the test file to run (e.g., `test/log_test.gd`)

## Steps

1. If no test file path is provided, list available test files in the `test/` directory and ask the user which one to run
2. Check if `GODOT_BIN` environment variable is set
3. If not set, ask the user for the Godot binary path
4. Run the test script with the specific test file: `sh addons/gdUnit4/runtest.sh --test <test_file_path>`
5. Show the test results to the user

## Usage Examples

```
/test-file test/log_test.gd
/test-file
```
