# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Running Tests
- `addons/gdUnit4/runtest.sh` - Run all tests using gdUnit4 framework
- `addons/gdUnit4/runtest.sh --godot_binary /path/to/godot` - Run tests with specific Godot binary
- The test script supports setting `GODOT_BIN` environment variable

### Project Structure
This is a Godot 4.5 project with the following key directories:
- `addons/log/` - Main Log.gd plugin implementation
- `addons/gdUnit4/` - Testing framework (external dependency)
- `src/` - Example scenes and resources demonstrating Log.gd usage
- `test/` - Test files for the Log.gd functionality

## Architecture

### Core Logging System
The main logging functionality is implemented in `addons/log/log.gd` as a static class that provides:

- **Pretty printing functions**: `Log.pr()`, `Log.prn()`, `Log.prnn()`, `Log.prnnn()` for different newline depths
- **Log level functions**: `Log.debug()`, `Log.info()`, `Log.warn()`, `Log.error()`
- **Color theming system**: Configurable color schemes via `LogColorTheme` resources
- **Type-specific formatting**: Custom rendering for vectors, dictionaries, arrays, objects, etc.

### Configuration System
Log.gd uses Godot's ProjectSettings for configuration with these key aspects:
- Settings are prefixed with `log_gd/config/`
- Default values are defined in `CONFIG_DEFAULTS` constant
- Runtime configuration via static methods like `Log.disable_colors()`, `Log.set_log_level()`
- Color themes loaded from `.tres` resource files

### Extensibility Features
- **Type overwrites**: `Log.register_type_overwrite()` for custom object formatting
- **Custom `to_pretty()` methods**: Objects can implement their own pretty-print logic
- **Configurable output depth**: Control newline formatting depth for nested structures

### Key Components
- **Core formatter**: `Log.to_pretty()` - converts any value to colored bb-code string
- **Call-site detection**: Automatically adds filename:line prefixes using `get_stack()`
- **Terminal compatibility**: Fallback color schemes for different environments
- **Performance considerations**: Array truncation for large collections

## Development Notes

### Testing
The project uses gdUnit4 for testing. Tests are located in `test/log_test.gd` and cover:
- Type-specific formatting (strings, numbers, vectors, arrays, dictionaries)
- Color output validation
- Configuration system behavior
- Newline and indentation logic

### Plugin Structure
Follows Godot addon conventions:
- `plugin.cfg` defines plugin metadata
- `plugin.gd` handles editor integration
- Core functionality in separate `log.gd` file for better organization

### Dependencies
- Godot 4.5+
- gdUnit4 (for testing only)
- No external runtime dependencies

### Development Workflow
1. Make changes to `addons/log/log.gd` for core functionality
2. Add/update tests in `test/log_test.gd`
3. Run tests with `sh addons/gdUnit4/runtest.sh`
