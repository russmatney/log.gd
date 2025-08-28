<p align="center">
  <a href="https://github.com/russmatney/log.gd/actions/workflows/ci.yml"><img alt="Unit Tests" src="https://github.com/russmatney/log.gd/actions/workflows/ci.yml/badge.svg" /></a>
</p>

<p align="center">
  <a href="https://www.patreon.com/russmatney">
    <img alt="russmatney on Patreon" src=https://img.shields.io/badge/Patreon-Support%20this%20Project-%23f1465a?style=for-the-badge />
  </a>
  <a href="https://discord.gg/PQvfdApHFQ">
    <img alt="dangerruss on Discord" src="https://img.shields.io/discord/758750490015563776?style=for-the-badge&logo=discord&logoColor=fff&label=discord" />
  </a>
  <a href="https://mastodon.gamedev.place/@russmatney">
    <img alt="russmatney on Mastodon" src="https://img.shields.io/badge/Mastodon-teal?style=for-the-badge&logo=mastodon&logoColor=white" />
  </a>
  <a href="https://www.twitch.tv/russmatney">
    <img alt="russmatney on Twitch" src="https://img.shields.io/badge/Twitch-purple?style=for-the-badge&logo=twitch&logoColor=white" />
  </a>
  <a href="https://www.youtube.com/@russmatney">
    <img src="https://img.shields.io/badge/Youtube-red?style=for-the-badge&logo=youtube&logoColor=white" alt="Youtube Badge"/>
  </a>
</p>

<hr>

<img src="/assets/Log_logo_2_4x.png">

# Log.gd, a Godot pretty printer

> Available on the [Godot Asset
> Library](https://godotengine.org/asset-library/asset/2696) and [Github](https://github.com/russmatney/log.gd).

> I gave [a Lightning talk](https://youtu.be/4Fv9YXHMA_U) about this addon at
> Godot Con Boston! Here are [the
> slides](https://docs.google.com/presentation/d/1Tlz8bLD4Uqltruwj7OmKIOr_InZrkWIvSDHUkQ_iJdY/edit#slide=id.p).

Log.gd provides a drop-in replacement for GDScript's `print(...)` function.

It colors the output based on the value passed in, and adds a prefix based on
the call-site's file and line number.

![Dino output logs (light theme)](/docs/assets/dino_example_output_light.png)

![Dino output logs (dark theme)](/docs/assets/dino_example_output_dark.png)

This makes Godot's `Output` buffer much more readable! And now, I can't live without it :eyeroll:

### TLDR

- `Log.pr(...)` is a `prints(...)` replacement (includes spaces between args)
- `Log.prn(...)`, `Log.prnn(...)`, and `Log.prnnn(...)` are the same, but
  include limited newlines + tabs when printing nested arrays and dictionaries
- Both add prefix with the calling filename and line number (e.g. `[Player:34]`)
- Both color the output values based on the value's type
- `Log.info(...)`, `Log.warn(...)`, `Log.error(...)` offer differing log levels

## Links

- [Docs](https://russmatney.github.io/log.gd/#/)
  - [Installation](https://russmatney.github.io/log.gd/#/?id=install)
  - [Features](https://russmatney.github.io/log.gd/#/?id=features)
  - [Public API](https://russmatney.github.io/log.gd/#/?id=public-api)
  - [Settings](https://russmatney.github.io/log.gd/#/?id=settings)
  - [Implementation](https://russmatney.github.io/log.gd/#/implementation)
- [Log.gd on the Godot Asset Library](https://godotengine.org/asset-library/asset/2696)

- [Color Constants Cheatsheet](https://raw.githubusercontent.com/godotengine/godot-docs/master/img/color_constants.png)

## Other Godot Loggers

There are some other great printers/loggers with a variety of features - check
them out!

- [gg.print](https://github.com/graydoubt/gg_print)
- [Loggie](https://github.com/Shiva-Shadowsong/loggie)
- [LogFox](https://github.com/HakaikuXiao/LogFox) - comparing values across runs
- [GoLogger](https://github.com/Burloe/GoLogger) - more production/release angled
- [https://github.com/ClumsyInker/godot-editor-log-highlighter](https://github.com/ClumsyInker/godot-editor-log-highlighter)
- [https://github.com/albinaask/Log](https://github.com/albinaask/Log)
- [https://gitlab.com/godot-stuff/gs-logger](https://gitlab.com/godot-stuff/gs-logger)
- [https://github.com/JohnDevlopment/godot-jlogger](https://github.com/JohnDevlopment/godot-jlogger)
- [https://github.com/raldone01/godot_addon_gdlogging_assetlib](https://github.com/raldone01/godot_addon_gdlogging_assetlib)
- [https://codeberg.org/Taffer/godot-logger](https://codeberg.org/Taffer/godot-logger)
- [https://github.com/DawnGroveStudios/GodotLogger](https://github.com/DawnGroveStudios/GodotLogger)
- [https://github.com/ZeeWeasel/LogDuck](https://github.com/ZeeWeasel/LogDuck)
- [https://github.com/DaviD4Chirino/Awesome-Debug-Log](https://github.com/DaviD4Chirino/Awesome-Debug-Log)

