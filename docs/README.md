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

> I gave a Lightning talk about this addon at Godot Con Boston!
> Here are [the
> slides](https://docs.google.com/presentation/d/1Tlz8bLD4Uqltruwj7OmKIOr_InZrkWIvSDHUkQ_iJdY/edit#slide=id.p).
> Video link to come soon!

Log.gd provides a drop-in replacement for GDScript's `print(...)` function.

It colors the output based on the value passed in, and adds a prefix based on
the call-site's file and line number.

![Dino output logs (light theme)](/assets/dino_example_output_dark.png)

![Dino output logs (dark theme)](/assets/dino_example_output_light.png)

This makes Godot's `Output` buffer much more readable!

### TLDR

- `Log.pr(...)` is a `print(...)` replacement (also adds spaces between args)
- `Log.prn(...)` is the same, but includes newlines + tabs when printing arrays
  and dictionaries

### Features

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
`to_pretty()`, which Log will pickup via duck-typing.

```gdscript
class_name ExampleClass

func to_pretty():
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
`to_pretty()`,
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
  - pretty-print with newlines AND push a warning via `push_warning`
- `Log.err(...)`, `Log.error(...)`
  - pretty-print with newlines AND push a error via `push_error`

?> These functions all take up to 7 args.
We could support more, but you can also just pass an Array or a Dictionary if you
need more args right away.

?> `Log.warn()` and `Log.err()` are nice because push_warning and push_error on
their own do not let you see warnings/errors in the same context as your usual
`print()` statements.
