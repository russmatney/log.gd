# CHANGELOG


## v0.0.7


### 11 May 2025

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
- ([`ff22e41`](https://github.com/russmatney/log.gd/commit/ff22e41)) chore: new version: v0.0.3
- ([`15ee689`](https://github.com/russmatney/log.gd/commit/15ee689)) chore: new version: v0.0.2
- ([`02f5951`](https://github.com/russmatney/log.gd/commit/02f5951)) feat: automate more of the release flow

  > Gluing it all together - tag creation, changelog update, commit and push.
  > 
  > Would be cool to error out if there's already a git-diff here as well.

- ([`097b950`](https://github.com/russmatney/log.gd/commit/097b950)) chore: new version: v0.0.2
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