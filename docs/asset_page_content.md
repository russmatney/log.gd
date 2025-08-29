# Log.gd, a Godot pretty printer

Log.gd provides a drop-in replacement for GDScript's `print(...)` function.

It colors the output based on the value passed in, and adds a prefix based on
the call-site's file and line number.

![Dino output logs (light theme)](/assets/dino_example_output_light.png)

![Dino output logs (dark theme)](/assets/dino_example_output_dark.png)

This makes Godot's `Output` buffer much more readable!

### TLDR

- `Log.pr(...)` is a `prints(...)` replacement (includes spaces between args)
- `Log.prn(...)` is the same, but includes newlines + tabs when printing arrays
  and dictionaries
- Both add prefix with the calling filename and line number (e.g. `[Player:34]`)
- Both color the output values based on the value's type
- `Log.info(...)`, `Log.warn(...)`, `Log.error(...)` offer differing log levels

### Links

- [Docs](https://russmatney.github.io/log.gd/#/)
  - [Installation](https://russmatney.github.io/log.gd/#/?id=install)
  - [Features](https://russmatney.github.io/log.gd/#/?id=features)
  - [Public API](https://russmatney.github.io/log.gd/#/?id=public-api)
  - [Settings](https://russmatney.github.io/log.gd/#/?id=settings)
  - [Implementation](https://russmatney.github.io/log.gd/#/implementation)
- [Github](https://github.com/russmatney/log.gd)
- [Log.gd on the Godot Asset Library](https://godotengine.org/asset-library/asset/2696)
- [Log.gd on the (new!) Godot Asset Store](https://godotengine.org/asset-library/asset/2696)

### Implementation and Quirks

There is some documentation of GDScript features that Log.gd uses and some
related quirks [on the Implementation Details page](https://russmatney.github.io/log.gd/#/implementation).

## Features

### Colorized output

The colorized output really shines when showing nested data structures (`Arrays`
and `Dictionaries`), but it's also very useful for other gdscript primitives,
like `Vectors`, `NodePaths`, and `StringNames`. Support for more types is easily
added, feel free to create an issue!

### Call-site prefixes

Log's print functions will prefix the output with the name of the script the log
comes from, including the line number.

NOTE: This call-site feature is really nice, but it is not yet available
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

### Type Handler Overwrites

You can 'register' handlers for built-in or otherwise 'closed' classes with
something like:

``` gdscript
Log.register_type_overwrite(some_obj.get_class(),
  func(val): return {name=val.name, level=val.level})
```

See the [type handlers functions](/?id=type-handlers).

### Color Themes

There is very rough color theme support. I'd like to develop this further, and
possibly align it more strongly with Godot's editor color themes.

For now it's a bit hard-coded...

## Public API

### Print functions

- `Log.pr(...)`, `Log.info(...)`
  - pretty-print without newlines
- `Log.prn(...)`, `Log.prnn(...)`, `Log.prnnn(...)`
  - pretty-print with limited newlines
- `Log.warn(...)`, `Log.todo(...)`
  - pretty-print without newlines
  - push a warning via `push_warning`
- `Log.err(...)`, `Log.error(...)`
  - pretty-print without newlines
  - push a error via `push_error`

These functions all take up to 7 args.
We could support more, but you can also pass an Array or a Dictionary if you
need more args right away.

`Log.warn()` and `Log.err()` are nice because `push_warning` and `push_error` on
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

### Type Handlers

You can 'register' handlers for built-in classes with the below functions.

- `register_type_overwrite(key: String, handler: Callable)`
  - the handler should be like `val: Variant -> Variant`
- `register_type_overwrites(overwrites: Dictionary)`
  - Overwrites is a dictionary like `{obj.get_class(): handler_func}`
- `clear_type_overwrites()`

## Settings

There are a few Log.gd options available in Project Settings.

It was pointed out to me that some of these should probably live as Editor
Settings instead of Project-wide ones. I'll be moving things around soon!

- `max_array_size` (`20`)
  - How many array elements to print.
- `dictionary_skip_keys` ([`layer_0/tile_data`])
  - Dictionary keys that are _always_ ignored (i.e. never printed.)
- `disable_colors` (`false`)
  - Disables colors at game startup.
- `color_theme` (`PRETTY_DARK_V1`)
  - A text string name that aligns with (currently hard-coded) color themes.
- `use_newlines` (`true`)
  - Setting to false disables newlines in `Log.prn()`, `Log.warn()`,
  `Log.todo()`, `Log.err()`, and `Log.error()`.
- `use_newlines` (`false`)
  - Setting to true enables newlines across all log functions.
- `newline_max_depth` (`-1`)
  - Limits the object depth where newlines are printed.  Negative values don't
  limit object depth.


## Contributors

Huge thanks to the Log.gd contributors!

- [cridenour](https://github.com/cridenour)
- [Gramps](https://github.com/Gramps)
- [gofastlily](https://github.com/gofastlily)
