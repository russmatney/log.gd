# CHANGELOG


## Unreleased


## v0.2.1


### 15 Nov 2025

- ([`c669ab9`](https://github.com/russmatney/log.gd/commit/c669ab9)) release: new version: v0.2.1
- ([`10c8ef7`](https://github.com/russmatney/log.gd/commit/10c8ef7): IAmThePoisonIvy) fixed bug

### 27 Sep 2025

- ([`388fbfc`](https://github.com/russmatney/log.gd/commit/388fbfc)) ci: use installed gdunit instead of pulling the latest stable
- ([`255a3e7`](https://github.com/russmatney/log.gd/commit/255a3e7)) deps: update gdunit

### 24 Sep 2025

- ([`fa0d576`](https://github.com/russmatney/log.gd/commit/fa0d576)) feat: Force Termsafe Colors config option

  > Adds a boolean config option that will opt-in to termsafe colors in
  > rebuild_config.
  > 
  > This lets users use term-safe colors without needing a script/autoload
  > to call `Log.use_termsafe_colors()`.
  > 
  > This used to be possible prior to the color-resource theme feature - in
  > the future we might consider a set of term-safe LogColorThemes to allow
  > folks to customize the termsafe colors as well.


### 20 Sep 2025

- ([`3ec44df`](https://github.com/russmatney/log.gd/commit/3ec44df)) ci: test on 4.5

## v0.2.0


### 20 Sep 2025

- ([`a059b7c`](https://github.com/russmatney/log.gd/commit/a059b7c)) release: v0.2.0

  > Optionally prepend timestamps


### 11 Sep 2025

- ([`55aa8d9`](https://github.com/russmatney/log.gd/commit/55aa8d9): Lily) Wrap timestamp in brackets

### 10 Sep 2025

- ([`cec8604`](https://github.com/russmatney/log.gd/commit/cec8604): Lily) Optionally prepend timestamps

### 31 Aug 2025

- ([`05ec206`](https://github.com/russmatney/log.gd/commit/05ec206): Lily) Use .callv() to showcase mixed arrays
- ([`059f3dc`](https://github.com/russmatney/log.gd/commit/059f3dc): Lily) Add button to set custom color

### 30 Aug 2025

- ([`9330d04`](https://github.com/russmatney/log.gd/commit/9330d04): Lily) Cleaning up and documenting ExampleScene, plus a neat lil' GUI

### 29 Aug 2025

- ([`a5ab049`](https://github.com/russmatney/log.gd/commit/a5ab049): Lily) Update documentation for `Log.debug()`
- ([`19f67b2`](https://github.com/russmatney/log.gd/commit/19f67b2)) docs: drop links from asset lib page, drop one-page install note

## v0.1.1


### 29 Aug 2025

- ([`6973203`](https://github.com/russmatney/log.gd/commit/6973203)) release: new version: v0.1.1
- ([`fe27f38`](https://github.com/russmatney/log.gd/commit/fe27f38)) fix: save ProjectSettings after setting new value

  > Need to save the new log-level so it gets written to project.godot
  > before starting the game.

- ([`8c90957`](https://github.com/russmatney/log.gd/commit/8c90957)) chore: update clj-kondo cruft

## v0.1.0


### 29 Aug 2025

- ([`2dc8ca9`](https://github.com/russmatney/log.gd/commit/2dc8ca9)) release: new version: v0.1.0
- ([`030d7fb`](https://github.com/russmatney/log.gd/commit/030d7fb)) docs: update changelog

  > Lots of great stuff in here from @gofastlily!

- ([`fb91ce3`](https://github.com/russmatney/log.gd/commit/fb91ce3): Lily) Add DEBUG log level below INFO
- ([`56975aa`](https://github.com/russmatney/log.gd/commit/56975aa): Lily) Add optional dropdown for quick log-level changing
- ([`476269f`](https://github.com/russmatney/log.gd/commit/476269f): Lily) Standalone reload scene plugin
- ([`8bffc8c`](https://github.com/russmatney/log.gd/commit/8bffc8c): Lily) Factor out reload scene button

### 28 Aug 2025

- ([`dbde3ec`](https://github.com/russmatney/log.gd/commit/dbde3ec)) chore: include log logo import files
- ([`6c765db`](https://github.com/russmatney/log.gd/commit/6c765db)) ci: drop godot 4.2 and 4.3

  > The 4.3 tests are failing b/c vectors print as 1.0 vs 1 between the
  > versions.
  > 
  > The 4.2 tests are failing b/c my gdunit version itself isn't 4.2
  > compat (for whatever reason).
  > 
  > Log.gd likely works fine on these versions, but for now I just want the
  > green checkmark - if there is a need to restore these, we can do so, but
  > most likely folks are moving to 4.4 and 4.5 these days anyway.

- ([`977e0ef`](https://github.com/russmatney/log.gd/commit/977e0ef)) docs: add contributors section
- ([`516cb15`](https://github.com/russmatney/log.gd/commit/516cb15)) fix: just disable_colors on warns/errors
- ([`44e9179`](https://github.com/russmatney/log.gd/commit/44e9179)) fix: drop/simplify some tests, drop cold-fire theme default

  > Gets tests passing again! heh. Will return to these in a future branch.
  > 
  > The coldfire theme is cool, but not quite ready yet.

- ([`768d599`](https://github.com/russmatney/log.gd/commit/768d599)) fix: ensure pretty=false on warning/error messages

  > We want to skip-pretty on the push_warning/push_error calls to keep them
  > readable in the debugger view.

- ([`cc4932b`](https://github.com/russmatney/log.gd/commit/cc4932b): Lily) Update documentation
- ([`4f1d041`](https://github.com/russmatney/log.gd/commit/4f1d041): Lily) Allow disabling of Log.todo() warning
- ([`fa91648`](https://github.com/russmatney/log.gd/commit/fa91648): Lily) Add filtering by log level
- ([`0897297`](https://github.com/russmatney/log.gd/commit/0897297): Lily) Remove delimiter_index in favor of newline_depth
- ([`e48dc6a`](https://github.com/russmatney/log.gd/commit/e48dc6a): Lily) Reorganize the example scene and ensure all showcase output gets printed
- ([`d011d06`](https://github.com/russmatney/log.gd/commit/d011d06): Lily) Implement prototype log features from Dot Hop

  > https://github.com/russmatney/dothop/commit/1c6e31d24c6d62386f99cd696b89985540f8db12

- ([`559a9c7`](https://github.com/russmatney/log.gd/commit/559a9c7): Lily) Use Log.get_use_newlines() within Log.to_pretty()

### 27 Aug 2025

- ([`a0ee1ce`](https://github.com/russmatney/log.gd/commit/a0ee1ce): Lily) Allow for single-line logs with Log.prn() and its aliases

### 24 Aug 2025

- ([`bfd25bc`](https://github.com/russmatney/log.gd/commit/bfd25bc)) feat: new logo on docs site, readme

  > Need to get this updated on the asset lib too.

- ([`51a4497`](https://github.com/russmatney/log.gd/commit/51a4497)) docs: add link to yt lightning talk

### 10 Aug 2025

- ([`e0b3351`](https://github.com/russmatney/log.gd/commit/e0b3351)) wip: coldfire theme, toying with bgcolor

  > Lots to clean up, but initial bgcolor testing is very positive! Excited
  > to add a coldfire and then autumnglow theme next.


### 4 Aug 2025

- ([`d9b29fa`](https://github.com/russmatney/log.gd/commit/d9b29fa)) docs: add changelog link to sidebar

### 1 Aug 2025

- ([`b3f3e45`](https://github.com/russmatney/log.gd/commit/b3f3e45)) docs: update changelog

## v0.0.9


### 1 Aug 2025

- ([`ba54359`](https://github.com/russmatney/log.gd/commit/ba54359)) feat: update log to v0.0.9
- ([`c745cc1`](https://github.com/russmatney/log.gd/commit/c745cc1)) docs: basic string on LogColorTheme
- ([`e76efbc`](https://github.com/russmatney/log.gd/commit/e76efbc)) docs: update changelog
- ([`06b96e6`](https://github.com/russmatney/log.gd/commit/06b96e6)) feat: Bring Your Own Color Theme!

  > Docs covering this fancy new feat

- ([`d86bae0`](https://github.com/russmatney/log.gd/commit/d86bae0)) refactor: split out color_theme_light/dark, more clean up

  > Moves the termsafe color fallback into the new resource class as well -
  > better to keep that giant list of type-maps together.

- ([`ee983dd`](https://github.com/russmatney/log.gd/commit/ee983dd)) refactor: misc color theme clean up, drops theme-overwrite features

  > Now that users can specify colors via their own color theme resource,
  > there's no need for color-theme-overwrite features. Please let me know
  > if you were using this and why!

- ([`d25606a`](https://github.com/russmatney/log.gd/commit/d25606a)) wip: proof of concept for BYO-colors

  > I'd hoped to load the LogColorTheme via project settings directly, but
  > we'll have to settle for a resource_path for now. Fortunately selecting
  > from project settings is a file-input, so it's not completely an empty
  > string field.

- ([`89964f9`](https://github.com/russmatney/log.gd/commit/89964f9)) wip: more toying with color theme custom resources

  > Not working yet - learning about editorPlugins vs actual game runtime rn.

- ([`b882f2c`](https://github.com/russmatney/log.gd/commit/b882f2c)) wip: toying with a LogColorTheme custom resource
- ([`542d33b`](https://github.com/russmatney/log.gd/commit/542d33b)) feat: enum type hint for color theme

  > Much nicer to select from a drop down than 'know' the supported theme
  > keys.
  > 
  > I toyed with moving these to EditorSettings, but unfortunately they
  > aren't available at runtime - so they're staying in ProjectSettings for
  > now. If you want a per-user overwrite, i suppose you could use feature
  > tags?


### 25 Jul 2025

- ([`67cacea`](https://github.com/russmatney/log.gd/commit/67cacea)) fix: disable colors in ios and web

  > ios and web look terrible with colors enabled - all the escape codes
  > clutter it up like cray cray.
  > 
  > We can get more sophisticated and prevent these from being called a
  > million times per log later on.

- ([`79b045b`](https://github.com/russmatney/log.gd/commit/79b045b)) fix: prevent a million logs when no theme is found

  > Closes #7


### 23 Jul 2025

- ([`7474546`](https://github.com/russmatney/log.gd/commit/7474546)) fix: better dark theme colors

  > I like the rainbow-delim feature quite alot, but the colors across the
  > themes are not great yet. Need to work toward exposing these so they
  > aren't so tied to the code.


## v0.0.8


### 23 Jul 2025

- ([`59f12d5`](https://github.com/russmatney/log.gd/commit/59f12d5)) release: v0.0.8
- ([`d70c597`](https://github.com/russmatney/log.gd/commit/d70c597)) docs: rainbow delimiter mention and image
- ([`6a1f413`](https://github.com/russmatney/log.gd/commit/6a1f413)) feat: cycle colors on dictionary keys too, plus restore tests

  > This also moves back to the original square brace usage - there's a
  > parsing bug in Godot 4.4.1 that leads to extra [/color] showing up, but
  > it's been fixed in Godot 4.5, so I'm gonna leave it for now.


### 22 Jul 2025

- ([`04ba989`](https://github.com/russmatney/log.gd/commit/04ba989)) wip: rainbow delimiters, square brace workaround

  > Pulls in the quick rainbow-delimiter impl from dothop, and the temporary
  > square brace workaround which uses (| |) in place of [ ] for now.
  > 
  > It's not very readable - hopefully there's a better option available,
  > needs more digging.


### 25 Jun 2025

- ([`39a9616`](https://github.com/russmatney/log.gd/commit/39a9616)) docs: add prior art, resized images

  > Prepping for the new godot asset store


### 18 May 2025

- ([`c7e51a2`](https://github.com/russmatney/log.gd/commit/c7e51a2)) wip: fix indentation bug, unit test with no assertion

  > Need to find a better way to test log's output - these raw string
  > comparisons are a bit of a pain to read and write.
  > 
  > Fixes the bug, at least.


### 16 May 2025

- ([`69a0d9b`](https://github.com/russmatney/log.gd/commit/69a0d9b)) chore: drop light theme setting
- ([`eee26b3`](https://github.com/russmatney/log.gd/commit/eee26b3)) docs: bit more for the TLDR
- ([`8326aa9`](https://github.com/russmatney/log.gd/commit/8326aa9)) docs: call out as a `prints` replacement
- ([`3933e07`](https://github.com/russmatney/log.gd/commit/3933e07)) docs: add line-number prefix to tldr

### 14 May 2025

- ([`071600a`](https://github.com/russmatney/log.gd/commit/071600a): GP Garcia) Update .gitattributes

### 11 May 2025

- ([`1d8d6c6`](https://github.com/russmatney/log.gd/commit/1d8d6c6)) chore: changelog updates

## v0.0.7


### 11 May 2025

- ([`cc51223`](https://github.com/russmatney/log.gd/commit/cc51223)) release: new version: v0.0.7
- ([`5ce83fd`](https://github.com/russmatney/log.gd/commit/5ce83fd)) fix: export-ignore non-log.gd addons
- ([`08c32e5`](https://github.com/russmatney/log.gd/commit/08c32e5)) fix: add export-ignore for everything but addons/

  > Much thanks to @Gramps for bringing this to my attention in #4.
  > 
  > This fix should prevent a bunch of unnecessary noise from being exported
  > and included when installing log via the godot asset library (in-editor).


### 10 May 2025

- ([`6707693`](https://github.com/russmatney/log.gd/commit/6707693)) fix: update note about call stack in production
- ([`f137d9a`](https://github.com/russmatney/log.gd/commit/f137d9a)) fix: public-api link
- ([`aa9afda`](https://github.com/russmatney/log.gd/commit/aa9afda)) docs: major rewrite (impl, homepage)

  > Fleshes out a bunch more details.

- ([`31d681a`](https://github.com/russmatney/log.gd/commit/31d681a)) docs: rough install instructions, some impl details
- ([`c7e3314`](https://github.com/russmatney/log.gd/commit/c7e3314)) wip: doc rewrite begins!

  > Simplifies intro, drops/dedupes readme content in favor of the docs site.


### 9 May 2025

- ([`4e0d6ba`](https://github.com/russmatney/log.gd/commit/4e0d6ba)) chore: bb docs for serving docsify locally

### 6 May 2025

- ([`ec1ecda`](https://github.com/russmatney/log.gd/commit/ec1ecda)) feat: add link to slides

### 30 Apr 2025

- ([`1cbf698`](https://github.com/russmatney/log.gd/commit/1cbf698)) wip: initial light theme, cleaned up showcase

### 28 Apr 2025

- ([`8171e27`](https://github.com/russmatney/log.gd/commit/8171e27)) wip: better showcase

### 26 Apr 2025

- ([`c1dd49d`](https://github.com/russmatney/log.gd/commit/c1dd49d)) fix: drop godot 4.5 tests

  > Not sure the expected syntax for this, and i can't find examples/docs
  > for it anywhere. W/e, no need to test future versions just yet.

- ([`f5aaf3f`](https://github.com/russmatney/log.gd/commit/f5aaf3f)) fix: update gdunit test action, use `sh` to run tests
- ([`39d4670`](https://github.com/russmatney/log.gd/commit/39d4670)) fix: update gdunit and .uid files

  > for some reason gdunit git-ignores .uid files, so we're stuck with these
  > rolling over every time we update. :eyeroll:


### 18 Mar 2025

- ([`0c46788`](https://github.com/russmatney/log.gd/commit/0c46788)) chore: drop godot 4.1 tests, update gdunit4-action version
- ([`ac24278`](https://github.com/russmatney/log.gd/commit/ac24278)) fix: we now always add a decimal to floats

  > b/c why not!

- ([`e6cb483`](https://github.com/russmatney/log.gd/commit/e6cb483)) fix: handle null return from project settings

  > This func expected a string, but these settings don't always exist.

- ([`a6dc262`](https://github.com/russmatney/log.gd/commit/a6dc262)) chore: a million billion uids

  > That will inevitably get updated when they land in gdunit itself

- ([`00e33be`](https://github.com/russmatney/log.gd/commit/00e33be)) chore: chmod gdunit test script

  > Gotta do this every time i update :eyeroll:

- ([`5b13f0e`](https://github.com/russmatney/log.gd/commit/5b13f0e)) deps: update gd-plug

  > unless godot generated this for me?

- ([`f71bba1`](https://github.com/russmatney/log.gd/commit/f71bba1)) ci: add godot 4.4 to tested versions
- ([`37282b3`](https://github.com/russmatney/log.gd/commit/37282b3)) deps: gdunit update
- ([`fe980cd`](https://github.com/russmatney/log.gd/commit/fe980cd)) chore: godot 4.4 uid updates

### 29 Jan 2025

- ([`9c5d4f8`](https://github.com/russmatney/log.gd/commit/9c5d4f8)) docs: update changelog
- ([`e92dc22`](https://github.com/russmatney/log.gd/commit/e92dc22)) fix: resolve type warnings in test file

  > Also disables a few more warnings - no need to handle return values in
  > test cases, and exclude_addons for now so we don't see a million gdunit
  > type warnings.
  > 
  > It should be noted that exclude_addons should be toggled while working
  > on log.gd to see the errors in that file.

- ([`b3472b1`](https://github.com/russmatney/log.gd/commit/b3472b1)) feat: satisfy the static type gods

  > Disables the unsafe cast check b/c the logic to deal with it would be
  > crazy in log's main Variant -> String function.
  > 
  > The move to `.call(method-name)` after `.has_method(method-name)` is
  > annoying but w/e that's what the tool is pushing us into. It's the same
  > result, anyway.

- ([`a5fe8b8`](https://github.com/russmatney/log.gd/commit/a5fe8b8)) wip: refactor log/log.gd to use static typing everywhere

  > Not quite zero errors yet - just need to figure out how to safe-cast.


### 12 Oct 2024

- ([`901adb5`](https://github.com/russmatney/log.gd/commit/901adb5)) feat: add Log.todo() for auto-prepending '[TODO]'

### 17 Aug 2024

- ([`444e920`](https://github.com/russmatney/log.gd/commit/444e920)) fix: don't use installed gdunit?
- ([`5ac864a`](https://github.com/russmatney/log.gd/commit/5ac864a)) feat: update to 4.3, include 4.3 in tests
- ([`e4f6479`](https://github.com/russmatney/log.gd/commit/e4f6479)) deps: update gdunit4

### 22 Jun 2024

- ([`fa781a3`](https://github.com/russmatney/log.gd/commit/fa781a3)) deps: update gdunit
- ([`05f9236`](https://github.com/russmatney/log.gd/commit/05f9236)) chore: test on 4.3.beta2

## v0.0.6


### 22 Jun 2024

- ([`91bf5d7`](https://github.com/russmatney/log.gd/commit/91bf5d7)) release: new version: v0.0.6
- ([`486a8c8`](https://github.com/russmatney/log.gd/commit/486a8c8)) todo: drop 0.7.0 todo tag
- ([`c6570b7`](https://github.com/russmatney/log.gd/commit/c6570b7)) docs: add godot-help friendly docstrings
- ([`b000997`](https://github.com/russmatney/log.gd/commit/b000997)) refactor: cleaner theme and type overwrites
- ([`3145b3e`](https://github.com/russmatney/log.gd/commit/3145b3e)) refactor: use consts instead of enum for config theme

  > I thought the enum would give the project settings a simple dropdown,
  > but it doesn't, so no need to take on the enum's problems for nothing.

- ([`da944b3`](https://github.com/russmatney/log.gd/commit/da944b3)) refactor: move to config theme enum

  > To ease project configuration, this moves from a big ole dictionary to
  > an enum for selecting a pre-existing theme. Really I'd like to support
  > custom themes, which won't work with this enum... but that can come
  > later.
  > 
  > Renames 'color_scheme' to 'color_theme'.

- ([`86b791a`](https://github.com/russmatney/log.gd/commit/86b791a)) docs: update changelog
- ([`bde09f1`](https://github.com/russmatney/log.gd/commit/bde09f1)) fix: changelog commit sorting
- ([`dce72d1`](https://github.com/russmatney/log.gd/commit/dce72d1)) chore: more clj-kondo hooks

### 20 Jun 2024

- ([`ff14ee4`](https://github.com/russmatney/log.gd/commit/ff14ee4)) chore: update discord link

### 6 Jun 2024

- ([`e2ba116`](https://github.com/russmatney/log.gd/commit/e2ba116)) docs: update changelog
- ([`af59d90`](https://github.com/russmatney/log.gd/commit/af59d90)) fix: prevent errors at startup, remove noisey logs

  > ProjectSettings-supported config seems to be working as expected!
  > Huzzah!

- ([`0251bdb`](https://github.com/russmatney/log.gd/commit/0251bdb)) refactor: move config from editor- to projectSettings

  > EditorSettings are per-machine and not accessible when starting
  > scenes (even from the editor). So instead we use the projectSettings,
  > to at least get these config vals going.
  > 
  > This might make more sense than editor settings, and could be useful to
  > override with feature tags and what not.
  > 
  > Still a bit of a mess, naming-wise, and seems to throw errors before the
  > settings have been created in the project :/

- ([`2a4f1c2`](https://github.com/russmatney/log.gd/commit/2a4f1c2)) ci: test fewer and updated godot versions
- ([`f231e70`](https://github.com/russmatney/log.gd/commit/f231e70)) deps: update gdunit4, ignore /test dir
- ([`4b137b7`](https://github.com/russmatney/log.gd/commit/4b137b7)) feat: introduce Log.gd editor-settings

  > Hooks into the editor_settings.settings_changed signal - towards
  > supporting setting custom values for Log.gd config options, such as
  > disable_colors and max_array_size. Not _quite_ working, but this is the
  > bulk of the work.

- ([`a1cc3e2`](https://github.com/russmatney/log.gd/commit/a1cc3e2)) fix: use installed gdunit version
- ([`0177263`](https://github.com/russmatney/log.gd/commit/0177263)) wip: vscode launch json, some basic ansi-code attempts
- ([`31ef24c`](https://github.com/russmatney/log.gd/commit/31ef24c)) feat: Log.disable_colors() and Log.enable_colors()

  > Color wrapping can now be globally disabled via Log.disable_colors().
  > This could help in some situations where the colors are not interpreted
  > and the output is an unreadable mess of `[color=blah][/color]` tags.


### 4 Jun 2024

- ([`92b62b0`](https://github.com/russmatney/log.gd/commit/92b62b0)) chore: update github funding links

### 6 May 2024

- ([`80238ba`](https://github.com/russmatney/log.gd/commit/80238ba)) license: add license to addons/log dir

### 13 Apr 2024

- ([`5719e6b`](https://github.com/russmatney/log.gd/commit/5719e6b)) deps: update gdunit
- ([`2bd6de4`](https://github.com/russmatney/log.gd/commit/2bd6de4)) deps: drop gd-plug-ui

  > I'm not using this anyway - dropping while i resolve whatever's up with CI.

- ([`ce88e7d`](https://github.com/russmatney/log.gd/commit/ce88e7d)) chore: drop editor plugin enter/exit

  > No need for this at the moment.

- ([`0ca78cc`](https://github.com/russmatney/log.gd/commit/0ca78cc)) fix: pass already colorized strings through
- ([`792026f`](https://github.com/russmatney/log.gd/commit/792026f)) fix: move SomeResource to @tool script
- ([`62d535f`](https://github.com/russmatney/log.gd/commit/62d535f)) test: more color overwriting coverage

  > A test covering overwriting a specific color via
  > Log.set_color_scheme(scheme)

- ([`f62b9e7`](https://github.com/russmatney/log.gd/commit/f62b9e7)) feat: support color overwriting via Log.to_pretty

  > The color schemes are now built once in Log.to_pretty, and merged into a
  > single map. This lets a minimal amount of colors be overwritten by a
  > passed dictionary, and leaves the rest of the colors as-is.
  > 
  > Passing color overwrites at the log callsite is a pain at the moment -
  > the variadic log functions don't make it clear where an opts dictionary
  > could be passed, and passing the result of Log.pretty to one of the
  > public Log funcs will print it as a string, which is not ideal

- ([`347a527`](https://github.com/russmatney/log.gd/commit/347a527)) ci: bump godot 4.2.2 test version
- ([`6bbac1d`](https://github.com/russmatney/log.gd/commit/6bbac1d)) ci: update gdunit4 action version
- ([`b8e5958`](https://github.com/russmatney/log.gd/commit/b8e5958)) feat: proof of concept for swapping color schemes

  > Inits a Log.config dictionary that pulls the color scheme from
  > config.color_scheme. The colors can also be passed to Log.to_pretty in
  > the opts dict.
  > 
  > Once the schemes are being merged, it'll be possible to overwrite
  > specific types without clearing the rest of the colors.
  > 
  > Ideally the prettier colors would be opt-ed into by the editor-launched
  > games, and the term-safe would be used in other circumstances (test
  > runners, 'built' production games)
  > 
  > A similar feature should make it easy to opt-out of colors - I wonder if
  > it's easy to read a `--log-no-colors` arg from the command line.

- ([`54d8bb2`](https://github.com/russmatney/log.gd/commit/54d8bb2)) todos: some documentation ideas
- ([`30d32f2`](https://github.com/russmatney/log.gd/commit/30d32f2)) docs: update changelog

  > Also auto-commits in `bb changelog`. Ideally this would be optional, but
  > i don't want to mess with the first arg - ought to up my
  > bb-task-cli-opts game a bit.

- ([`4e2241c`](https://github.com/russmatney/log.gd/commit/4e2241c)) feat: Log.register_overwrite(type_or_class, func(x, opts))

  > Adds support for registering a handler for a type or class. The handler
  > is stored on a Log.log_overwrites static var and used to cut off the
  > default log implementation for that type/class.
  > 
  > Easier than i thought to implement! Perhaps we could use a similar
  > structure for log's config data (e.g. max_array_size, color_scheme, etc)

- ([`fc43d65`](https://github.com/russmatney/log.gd/commit/fc43d65)) test: basic custom_resource coverage

  > Not necessarily the behavior we want, but here's what we've got for now.


### 12 Apr 2024

- ([`d06b6bb`](https://github.com/russmatney/log.gd/commit/d06b6bb)) chore: misc bb release improvements

## v0.0.5


### 12 Apr 2024

- ([`f583a19`](https://github.com/russmatney/log.gd/commit/f583a19)) chore: new version: v0.0.5
- ([`d13aea0`](https://github.com/russmatney/log.gd/commit/d13aea0)) docs: update changelog
- ([`8abba09`](https://github.com/russmatney/log.gd/commit/8abba09)) fix: don't over indent arrays of dicts

  > the opts dictionary was being updated in place, which was resulting in
  > the third dictionary in an array being indented three times (instead of 1).
  > 
  > Notably the tests don't cover whitespace very well at the moment, but
  > w/e, it's fixed.

- ([`b8de312`](https://github.com/russmatney/log.gd/commit/b8de312)) test: coverage for vectors, null, bool, etc

  > Adds coverage for more types, and stubs test code/todos for more that
  > deserve coverage.

- ([`e3cc213`](https://github.com/russmatney/log.gd/commit/e3cc213)) feat: support to_pretty() and Log.to_pretty()

  > Log.to_pretty(obj) can be used to get a colorized string version of the
  > passed object - this is what is eventually printed via print_rich, but
  > it can be useful for UIs as well (e.g. passed into a RichText Label)
  > 
  > to_pretty() is now a third method that can be implemented on an
  > object/class/custom_resource to specify the logged data when that object
  > is logged.
  > 
  > Also refactors and fixes the tests a bit, in preparation for testing
  > more types.

- ([`38a506d`](https://github.com/russmatney/log.gd/commit/38a506d)) refactor: add Custom Resource to example scene

  > Adds a basic Custom Resource with a to_printable func to show the
  > currently supported case.

- ([`34c4b03`](https://github.com/russmatney/log.gd/commit/34c4b03)) feat: support vector3s and 4s, some color tweaks

### 27 Mar 2024

- ([`e8d7b05`](https://github.com/russmatney/log.gd/commit/e8d7b05)) fix: restore current tests after color changes

  > Ideally these wouldn't be so brittle - maybe swapping in color palettes
  > will help.

- ([`b7241fa`](https://github.com/russmatney/log.gd/commit/b7241fa)) wip: initial PackedScene and RefCounted handling

  > Now printing a short filename for the resource_path behind the logged
  > PackedScene or RefCounted object, if it exists. Could perhaps get wiser
  > about applying this to more types, but for now I'm hitting objects that
  > show up in my own work, and these seemed like a quick win.
  > 
  > Testing to come before the next version release!


### 26 Mar 2024

- ([`bf31411`](https://github.com/russmatney/log.gd/commit/bf31411)) fix: prettier colors, fix test/addons mixup
- ([`35e82c7`](https://github.com/russmatney/log.gd/commit/35e82c7)) refactor: towards swappable color schemes

  > Refactors to_pretty, pulling color-selection completely into the
  > color_wrap function. Adds two basic color schemes, which are really not
  > that different at the moment - these are dictionaries that support a
  > bunch of `typeof` ints and some specific type overwrites for various
  > punctutation, dictionary keys, vector vals, etc.
  > 
  > It's a bit annoying to work with these as static vars b/c the editor
  > keeps their initial state, which hurts the feedback loop if you edit and
  > want to see nice logs without running the whole game. Probably these
  > will need to move to configs or some other place at some point.
  > 
  > Not loving the green or color choices in general yet - i'll have to dig
  > up my original screenshots from last year.
  > 
  > Also, could use some test coverage on this! For now, the colors are
  > still hard-coded (i.e. not swappable).


### 24 Mar 2024

- ([`6449476`](https://github.com/russmatney/log.gd/commit/6449476)) docs: update changelog

  > Also adds the `bb changelog` task back.

- ([`8814055`](https://github.com/russmatney/log.gd/commit/8814055)) fix: api docs on docsify homepage

### 23 Mar 2024

- ([`f5623cd`](https://github.com/russmatney/log.gd/commit/f5623cd): Chris Ridenour) Fix API descriptions in README.md

  > It seemed weird when I read these functions didn't create newlines, but upon looking at the source realized they did.


### 22 Mar 2024

- ([`541c1c0`](https://github.com/russmatney/log.gd/commit/541c1c0)) chore: add gd-plug bb task, drop unused tasks
- ([`2ffa981`](https://github.com/russmatney/log.gd/commit/2ffa981)) docs: hide/show based on arbitrary categories

  > Much thanks to bryce dixon for the idea!

- ([`dcff941`](https://github.com/russmatney/log.gd/commit/dcff941)) docs: get to the point
- ([`e6e980c`](https://github.com/russmatney/log.gd/commit/e6e980c)) fix: use proper asset lib link
- ([`349dab4`](https://github.com/russmatney/log.gd/commit/349dab4)) fix: drop godot 4.0, which Log is not compatibel with!
- ([`f4224ac`](https://github.com/russmatney/log.gd/commit/f4224ac)) fix: add godot 4.0 version
- ([`c778d26`](https://github.com/russmatney/log.gd/commit/c778d26)) docs: add link to godot asset lib
- ([`1f58168`](https://github.com/russmatney/log.gd/commit/1f58168)) docs: add badges to readme and docs site

### 21 Mar 2024

- ([`6ba4738`](https://github.com/russmatney/log.gd/commit/6ba4738)) docs: misc todos

## v0.0.4


### 21 Mar 2024

- ([`c34c260`](https://github.com/russmatney/log.gd/commit/c34c260)) chore: new version: v0.0.4
- ([`7e5bcbd`](https://github.com/russmatney/log.gd/commit/7e5bcbd)) refactor: update repo name from log to log.gd

  > Hopefully doesn't break everything!

- ([`3a3bacf`](https://github.com/russmatney/log.gd/commit/3a3bacf)) fix: readme markdown fixes
- ([`d33c3d0`](https://github.com/russmatney/log.gd/commit/d33c3d0)) docs: cover call-site prefixes
- ([`b03f19e`](https://github.com/russmatney/log.gd/commit/b03f19e)) feat: add line numbers to call-site prefixes
- ([`dd106ae`](https://github.com/russmatney/log.gd/commit/dd106ae)) wip: readme rewriting
- ([`0c3e360`](https://github.com/russmatney/log.gd/commit/0c3e360)) fix: correct readme image urls
- ([`6b2a31a`](https://github.com/russmatney/log.gd/commit/6b2a31a)) docs: v1 docs site with quick hits
- ([`fdfa25b`](https://github.com/russmatney/log.gd/commit/fdfa25b)) docs: init basic docsify pages

## v0.0.3


### 21 Mar 2024

- ([`ff22e41`](https://github.com/russmatney/log.gd/commit/ff22e41)) chore: new version: v0.0.3
- ([`15ee689`](https://github.com/russmatney/log.gd/commit/15ee689)) chore: new version: v0.0.2
- ([`02f5951`](https://github.com/russmatney/log.gd/commit/02f5951)) feat: automate more of the release flow

  > Gluing it all together - tag creation, changelog update, commit and push.
  > 
  > Would be cool to error out if there's already a git-diff here as well.


## v0.0.2


### 21 Mar 2024

- ([`097b950`](https://github.com/russmatney/log.gd/commit/097b950)) chore: new version: v0.0.2

## v0.0.1


### 21 Mar 2024

- ([`03043d0`](https://github.com/russmatney/log.gd/commit/03043d0)) chore: version and changelog update
- ([`c0a9e37`](https://github.com/russmatney/log.gd/commit/c0a9e37)) docs: extend changelog to specify a latest version label

  > This lets me write the changelog with the new tag before it actually
  > exists. There's a chicken-and-egg problem with using tags to create the
  > changelog - i want the changelog update included in the tagged commit
  > itself, so we have to fake the tag's existence first.

- ([`a8dd5c3`](https://github.com/russmatney/log.gd/commit/a8dd5c3)) docs: monospace hashes and subject lines
- ([`7a29c89`](https://github.com/russmatney/log.gd/commit/7a29c89)) docs: changelog hashes first

  > More scannable! I think this is done.

- ([`d469913`](https://github.com/russmatney/log.gd/commit/d469913)) docs: changelog commits grouped by date
- ([`30eb286`](https://github.com/russmatney/log.gd/commit/30eb286)) docs: changelog formatting - bodies as comments

  > I'm hopeful this ends up being more readable.

- ([`7e210ae`](https://github.com/russmatney/log.gd/commit/7e210ae)) feat: generating initial changelog
- ([`f3be3be`](https://github.com/russmatney/log.gd/commit/f3be3be)) wip: bb code gathering commits per tag

## v0.0.0


### 21 Mar 2024

- ([`e00bc10`](https://github.com/russmatney/log.gd/commit/e00bc10)) feat: plugin version, split out todos
- ([`1c7b719`](https://github.com/russmatney/log.gd/commit/1c7b719)) chore: expand ci to cover more godot versions

### 20 Mar 2024

- ([`8500f27`](https://github.com/russmatney/log.gd/commit/8500f27)) feat: add logo
- ([`83b633a`](https://github.com/russmatney/log.gd/commit/83b633a)) readme: split out v0.1 vs v1.0 todos
- ([`77cebdc`](https://github.com/russmatney/log.gd/commit/77cebdc)) docs: attempt to make org/github rendering work better

  > surprised the image name/captions don't work!

- ([`fcf7aed`](https://github.com/russmatney/log.gd/commit/fcf7aed)) Create LICENSE
- ([`59d76e8`](https://github.com/russmatney/log.gd/commit/59d76e8)) docs: readme todos update
- ([`134072c`](https://github.com/russmatney/log.gd/commit/134072c)) feat: readme images and example.gd

  > also refactors to_pretty to use an opts dictionary instead of continuing
  > to add optional params. This should create some space for more options
  > and clean up the impl going forward.

- ([`1bce1eb`](https://github.com/russmatney/log.gd/commit/1bce1eb)) feat: support Object.to_printable() via duck-typing

  > Any object can now opt-in to some other logged form by implementing an
  > arg-less to_printable() function.
  > 
  > I wanted something cute, but `log()` already does logarithms, and pr()
  > or pp() felt obscure for a public function.

- ([`537e43a`](https://github.com/russmatney/log.gd/commit/537e43a)) chore: test coverage for strings
- ([`b900292`](https://github.com/russmatney/log.gd/commit/b900292)) fix: run ci on push
- ([`ab2553c`](https://github.com/russmatney/log.gd/commit/ab2553c)) ci: initial gdunit4 github action

  > Straight outta https://mikeschulze.github.io/gdUnit4/faq/ci/

- ([`737f4d5`](https://github.com/russmatney/log.gd/commit/737f4d5)) dep: add gd-plug-ui
- ([`05213c0`](https://github.com/russmatney/log.gd/commit/05213c0)) feat: update gdUnit4
- ([`190724e`](https://github.com/russmatney/log.gd/commit/190724e)) feat: install and init gd-plug

### 9 Mar 2024

- ([`aba54f2`](https://github.com/russmatney/log.gd/commit/aba54f2)) docs: more todos/readme outline
- ([`c70815a`](https://github.com/russmatney/log.gd/commit/c70815a)) test: quick dictionary test

  > just copy-pasting the output back into the test. aka snapshot testing?

- ([`ed7b0c3`](https://github.com/russmatney/log.gd/commit/ed7b0c3)) chore: clean up some bits

  > Experimented with more readable bbcode output, only to learn that you
  > can just 'print' it. heh.

- ([`0ca946f`](https://github.com/russmatney/log.gd/commit/0ca946f)) test: impl some basic tests

### 16 Feb 2024

- ([`64c0d23`](https://github.com/russmatney/log.gd/commit/64c0d23)) feat: first basic test running (and failing)
- ([`7b9f964`](https://github.com/russmatney/log.gd/commit/7b9f964)) feat: run tests bia bb test/test-match
- ([`2870db0`](https://github.com/russmatney/log.gd/commit/2870db0)) chore: add gdunit
- ([`28ebf33`](https://github.com/russmatney/log.gd/commit/28ebf33)) feat: example scene
- ([`e6663de`](https://github.com/russmatney/log.gd/commit/e6663de)) feat: pull in log impl and init plugin