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

# Log.gd, a Godot pretty printer

> Available on the [Godot Asset
> Library](https://godotengine.org/asset-library/asset/2696) and [Github](https://github.com/russmatney/log.gd).

> I gave [a Lightning talk](https://youtu.be/4Fv9YXHMA_U) about this addon at
> Godot Con Boston! Here are [the
> slides](https://docs.google.com/presentation/d/1Tlz8bLD4Uqltruwj7OmKIOr_InZrkWIvSDHUkQ_iJdY/edit#slide=id.p).

Log.gd provides a drop-in replacement for GDScript's `print(...)` function.

It colors the output based on the value passed in, and adds a prefix based on
the call-site's file and line number.

![Dino output logs (light theme)](/assets/dino_example_output_light.png)

![Dino output logs (dark theme)](/assets/dino_example_output_dark.png)

This makes Godot's `Output` buffer much more readable!

### TLDR

- `Log.pr(...)` is a `prints(...)` replacement (includes spaces between args)
- `Log.prn(...)`, `Log.prnn(...)`, and `Log.prnnn(...)` are the same, but
  include limited newlines + tabs when printing nested arrays and dictionaries
- Both add prefix with the calling filename and line number (e.g. `[Player:34]`)
- Both color the output values based on the value's type
- `Log.debug(...)`, `Log.info(...)`, `Log.warn(...)`, `Log.error(...)` offer differing log levels

### Links

- [Docs (this page)](https://russmatney.github.io/log.gd/#/)
  - [Installation](https://russmatney.github.io/log.gd/#/?id=install)
  - [Features](https://russmatney.github.io/log.gd/#/?id=features)
  - [Public API](https://russmatney.github.io/log.gd/#/?id=public-api)
  - [Settings](https://russmatney.github.io/log.gd/#/?id=settings)
  - [Implementation](https://russmatney.github.io/log.gd/#/implementation)
- [Github](https://github.com/russmatney/log.gd)
- [Log.gd on the Godot Asset Library](https://godotengine.org/asset-library/asset/2696)

### Implementation and Quirks

There is some documentation of GDScript features that Log.gd uses and some
related quirks [on this Implementation Details page](/implementation).

## Installation

### Godot Asset Library

Log.gd is [here on the Godot Asset
Library](https://godotengine.org/asset-library/asset/2696), so can be installed
directly via the Godot Editor's `Asset Lib` tab.

### Via Github

- Clone the [Repo](https://github.com/russmatney/log.gd) somewhere locally
- Move the `addons/log/` folder into your game's `addons` directory


## Features

### Colorized output

The colorized output really shines when showing nested data structures (`Arrays`
and `Dictionaries`), but it's also very useful for other gdscript primitives,
like `Vectors`, `NodePaths`, and `StringNames`. Support for more types is easily
added, feel free to create an issue!

Support for "rainbow-delimiters" (cycling colors on nested brackets and
dictionary keys) was added in `v0.0.8`!

![Rainbow Delimiters](/assets/rainbow_delimiters.png)

### Call-site prefixes

Log's print functions will prefix the output with the name of the script the log
comes from, including the line number.

!> This call-site feature is really nice, but it is not yet available
everywhere! Recent Godot builds (`4.5-dev3`) provide the call-stack to more
enviroments, and I need to do some testing to confirm whether this now works in
production builds.

### Objects and `to_pretty()`

You can opt-in to pretty-printing in your classes by implementing
`to_pretty()`, which Log will pickup via duck-typing.

```gdscript
class_name ExampleClass

func to_pretty():
    return {val=12}

func _ready():_
    Log.pr(self) # colorized `{"val": 12}`
```

TODO: pull in obj before/after images

### Type Handler Overwrites

You can 'register' handlers for built-in or otherwise 'closed' classes with
something like:

``` gdscript
Log.register_type_overwrite(some_obj.get_class(),
  func(val): return {name=val.name, level=val.level})
```

See the [type handlers functions](/?id=type-handlers).

### Bring Your Own Color Theme!

As of `v0.0.9` you can create your own `LogColorTheme` and set it via the
`Project > Settings > Log.gd`.

Log ships with an initial dark and light theme - feel free to duplicate and
customize as you would. I'd love to provide more themes out of the box, feel
free to share them via PR or otherwise.

### Log Levels!

Log.gd supports four log levels, `DEBUG`, `INFO`, `WARN`, and `ERROR`.  These levels have
matching logger functions for ease of use: `Log.debug()`, `Log.info()`, `Log.warn()`, and
`Log.error()`.  For convenience, `Log.err()` is available.

`Log.todo()` is treated as a `WARN`-level log by default, but can be changed to
an `INFO`-level log in Project Settings or via `Log.disable_warn_todo()`.

### Optionally Customizable Timestamps!

Log.gd can prepend timestamps to log lines if needed.

The timestamp options available are a Unix timestamp, the ticks in microseconds or nanoseconds, and human readable in 12 or 24 hour time.


## Public API

### Print functions

- `Log.pr(...)`, `Log.debug(...)`, `Log.info(...)`
  - pretty-print without newlines
- `Log.prn(...)`, `Log.prnn(...)`, `Log.prnnn(...)`
  - pretty-print with limited newlines
- `Log.warn(...)`
  - pretty-print without newlines
  - push a warning via `push_warning`
- `Log.err(...)`, `Log.error(...)`
  - pretty-print without newlines
  - push a error via `push_error`
- `Log.todo(...)`
  - pretty-print without newlines
  - optionally push a warning via `push_warning`

?> These functions all take up to 7 args.
We could support more, but you can also pass an Array or a Dictionary if you
need more args right away.

?> `Log.warn()` and `Log.err()` are nice because `push_warning` and `push_error` on
their own do not let you see warnings/errors in the same context as your usual
`print()` statements.

### Returning a string

- `Log.to_pretty(msg: Variant, opts: Dictionary = {}) -> String`

`Log.to_pretty(val)` can be used to get a bb-code wrapped string, maybe to be
passed into a `RichTextLabel`.

### Toggling features

A few functions I use to tweak things at run time (e.g. when running tests).

- `Log.enable_colors()`
- `Log.disable_colors()`
- `Log.set_colors_termsafe()`
- `Log.set_colors_pretty()`
- `Log.enable_newlines()`
- `Log.disable_newlines()`
- `Log.set_newline_max_depth(new_depth: int)`
- `Log.reset_newline_max_depth()`
- `Log.set_log_level()`
- `Log.disable_warn_todo()`
- `Log.enable_warn_todo()`
- `Log.show_timestamps()`
- `Log.hide_timestamps()`
- `Log.use_timestamp_type(timestamp_type: Log.TimestampTypes)`
- `Log.use_timestamp_format(timestamp_format: String)`

### Type Handlers

You can 'register' handlers for built-in classes with the below functions.

- `register_type_overwrite(key: String, handler: Callable)`
  - the handler should be like `val: Variant -> Variant`
- `register_type_overwrites(overwrites: Dictionary)`
  - Overwrites is a dictionary like `{obj.get_class(): handler_func}`
- `clear_type_overwrites()`

### Timestamp Format

The default timestamp format is `{hour}:{minute}:{second}`.  The supported
fields are `year`, `month`, `day`, `weekday`, `hour`, `minute`, `second`,
`meridiem` and `dst`.`

Both `minute` and `second` have preceeding zeroes for both 12- and 24-hour time.
`hour` only has a preceeding zero when using 24-hour time.  Both `month` and
`day` also have preceeding zeroes for both 12- and 24-hour time.

## Settings

There are a few Log.gd options available in Project Settings.

> It was pointed out to me that some of these should probably live as Editor
> Settings instead of Project-wide ones. I'll be moving things around soon!

- `max_array_size` (`20`)
  - How many array elements to print.
- `dictionary_skip_keys` ([`layer_0/tile_data`])
  - Dictionary keys that are _always_ ignored (i.e. never printed.)
- `disable_colors` (`false`)
  - Disables colors at game startup.
- `color_theme` (`PRETTY_DARK_V1`)
  - A text string name that aligns with (currently hard-coded) color themes.
- `use_newlines` (`false`)
  - Setting to true enables newlines across all log functions.
- `newline_max_depth` (`-1`)
  - Limits the object depth where newlines are printed.  Negative values don't
  limit object depth.
- `log_level` (`Info`)
  - Sets the project-wide, minimum level to log.
- `warn_todo` (`true`)
  - Setting true causes `Log.todo()` to be treated as a warn-level log, false
  and it gets treated as an info-level log.
- `show_timestamps` (`false`)
  - Setting to `true` prepends timestamps for log lines.
- `timestamp_type` (`HUMAN_12HR`)
  - Select the type of timestamp printed in the logs.  Options are `UNIX`,
  `TICKS_MSEC`, `TICKS_USEC`, `HUMAN_12HR`, and `HUMAN_24HR`.
- `human_readable_timestamp_format` (`{hour}:{minute}:{second}`)
  - Custom format string for human-readable timestamps.  `meridiem` is only
  available when using 12-hour time.

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

## Contributors

Huge thanks to the Log.gd contributors!

- [cridenour](https://github.com/cridenour)
- [Gramps](https://github.com/Gramps)
- [gofastlily](https://github.com/gofastlily)
- [IAmTraffic](https://github.com/IAmTraffic)
- [Fox-Alpha](https://github.com/Fox-Alpha)

