# CHANGELOG


## Unreleased


### 12 Apr 2024

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

- ([`f5623cd`](https://github.com/russmatney/log.gd/commit/f5623cd)) Fix API descriptions in README.md

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