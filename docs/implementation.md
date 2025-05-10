# Implementation Details

It's not necessary to know these things to use Log.gd, but I wanted to document
some Godot + GDScript features that made it possible.

This should make it easy to implement yourself, or add to your own logging
library. Go for it, and feel free to ping me for help!

# GDScript features

## `print_rich` and `BBCode`

Log.gd's print helpers are wrappers around `print_rich`, which
expects `BBCode`-wrapped strings.

BBCode is a markup format similar to xml tags - prefixes like `[color=green]` or
`[b]` wrap some text before a closing tags (`[/color]` or `[/b]`).

You can find more in the Godot docs:

- [`print_rich`](https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#class-globalscope-method-print-rich)
- [RichTextLabel](https://docs.godotengine.org/en/stable/classes/class_richtextlabel.html#class-richtextlabel)
- [BBcode in RichTextLabel tutorial](https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html)

> NOTE: note all outputs support all colors. See [Term Safe
> Colors](/implementation?id=term-safe-colors) below.

## `get_stack()`

The call-site file, function name, and line number are all pulled via
`get_stack`, which returns an array of dictionaries like:

```
[
  {function:bar,    line:12, source:res://script.gd},
  {function:foo,    line:9,  source:res://script.gd},
  {function:_ready, line:6,  source:res://script.gd}
]
```

There are currently some quirks to this - requiring an editor instance, not
working threads or tool scripts - but some recent (Godot `4.5-dev3`) updates have
extended the stack's abilities into production builds. :yay:

We could also be pulling the function name into the prefix, which might be nice.

See also:

- [`get_stack` in Godot's docs](https://docs.godotengine.org/en/stable/classes/class_@gdscript.html#class-gdscript-method-get-stack)

## Static Class Methods vs Autoloads

Log's original implementation was part of a `Debug` autoload.

When static class methods were introduced, Log was moved to its own class and
methods, roughly:

``` gdscript
class_name Log

static func pr(arg=null):
    var line = do_magic(arg)
    print_rich(line)
```

This makes it dead simple to call `Log.pr()` anywhere without "autoloading" a
node, etc.

This is a great way to write a bunch of pure functions that are accessible to
the rest of your program. However, there is a potential issue with naming
collisions (if anyone else wants their own `class_name Log`). See
[namespaces](/implementation?id=namespaces).


# Quirks

## "Term Safe" colors

Godot's editor supports many colors, but terminals support only a
subset, and other outputs (e.g. browser consoles) support none.

Log.gd has helpers to switch to "Term Safe" Colors
(`Log.set_colors_termsafe()`) or disable colors completely
(`Log.disable_colors()`) to maintain readable output.

## Namespaces

Log.gd squats on a `Log` class name. GDScript does not have a workaround for
this - class name collisions will occur, and one or the other needs to be
changed.

A potential solution to this is namespaces - there is an open issue discussing
this here: https://github.com/godotengine/godot-proposals/issues/1566

Alternatively, we could rename the class published with Log to something like
`L` or `PrettyPrint` or something more unique/specific.


