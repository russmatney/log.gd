<p align="center">
  <a href="https://github.com/russmatney/log.gd/actions/workflows/ci.yml"><img alt="Unit Tests" src="https://github.com/russmatney/log.gd/actions/workflows/ci.yml/badge.svg" /></a>
</p>

<p align="center">
  <a href="https://www.patreon.com/russmatney">
    <img alt="russmatney on Patreon" src=https://img.shields.io/badge/Patreon-Support%20this%20Project-%23f1465a?style=for-the-badge />
  </a>
  <a href="https://discord.gg/xZHWtGfAvF">
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

> Now available on the [Godot Asset
> Library](https://godotengine.org/asset-library/asset/2696) and [github](https://github.com/russmatney/log.gd).

### Quick Overview

Log.gd provides static functions for printing colorized output. These
are intended as drop-in replacements for `print(...)`.

- `Log.pr(...)` - pretty print args in one line
- `Log.prn(...)` - the same, but with newlines

This is very useful while developing, because your printed output is much more readable.

#### Colorized output

The colorized output really shines when showing nested data structures (`Arrays`
and `Dictionaries`), but it's also very useful for other gdscript primitives,
like `Vectors`, `NodePaths`, and `StringNames`. Support for more types is easily
added, feel free to create an issue!

#### Call-site prefixes

Log's print functions will prefix the output with the name of the script the log
comes from, including the line number.

!> This call-site feature is really nice! Unfortunately it can only be used
during development - it depends on `get_stack()`, which is not available in
production builds or at `@tool` script time.

#### Opt-in via duck-typing

You can opt-in to pretty-printing in your classes by implementing
`to_printable()`, which Log will pickup via duck-typing.

```gdscript
class_name ExampleClass

func to_printable():
    return {val=12}

func _ready():_
    Log.pr(self) # colorized `{"val": 12}`
```


### Example script and output

Checkout [src/Example.gd](https://github.com/russmatney/log.gd/blob/main/src/Example.gd) for this code.

`Log.pr()` colorizes and prints passed arguments, including recursively digging
into Arrays and Dictionaries.

![`Log.pr()` should Just Work in most (all?) cases](/assets/example_gd_impl.png)

`Log.pr()` should Just-Work in most (all?) cases.

You can opt-in to pretty printing in your objects by implementing
`to_printable()`,
which gets picked up by Log's static method via duck-typing.

![output of Example.gd](/assets/example_gd_output.png)

This makes dictionaries and arrays much more readable at a glance, which speeds
up debugging and reduces eye-strain.

Compare the above output with the usual from `print(...)`:

![output with only print statements](/assets/example_print_output.png)

### Public API

- `Log.pr(...)`, `Log.info(...)`, `Log.log(...)`
  - pretty-print without newlines
- `Log.prn(...)`
  - pretty-print with newlines
- `Log.warn(...)`
  - pretty-print without newlines AND push a warning via `push_warning`
- `Log.err(...)`, `Log.error(...)`
  - pretty-print without newlines AND push a error via `push_error`

?> These functions all take up to 7 args.
We could support more, but you can also just pass an Array or a Dictionary if you
need more args right away.

?> `Log.warn()` and `Log.err()` are nice because push_warning and push_error on
their own do not let you see warnings/errors in the same context as your usual
`print()` statements.
