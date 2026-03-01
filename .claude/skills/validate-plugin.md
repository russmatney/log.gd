---
name: validate-plugin
description: Validate the Log.gd plugin structure and configuration
invocableByUser: true
---

# Validate Plugin Skill

Validate the Log.gd plugin structure and configuration.

## Steps

1. Check that `plugin.cfg` exists in `addons/log/` and has the correct format
2. Verify that `log.gd` exists and has the main Log class
3. Check that all required files are present:
   - `addons/log/plugin.cfg`
   - `addons/log/plugin.gd`
   - `addons/log/log.gd`
4. Verify the `plugin.cfg` has required fields: name, description, author, version, script
5. Report any issues or confirm that the plugin structure is valid

## Validation Checklist

- [ ] `plugin.cfg` exists and is properly formatted
- [ ] `plugin.gd` exists (editor integration)
- [ ] `log.gd` exists (core functionality)
- [ ] All required metadata fields are present
- [ ] File structure follows Godot plugin conventions
