# CHANGELOG


## Unreleased


### 21 Mar 2024

- [d469913](https://github.com/russmatney/log/commit/d469913): docs: changelog commits grouped by date
- [30eb286](https://github.com/russmatney/log/commit/30eb286): docs: changelog formatting - bodies as comments

  > I'm hopeful this ends up being more readable.

- [7e210ae](https://github.com/russmatney/log/commit/7e210ae): feat: generating initial changelog
- [f3be3be](https://github.com/russmatney/log/commit/f3be3be): wip: bb code gathering commits per tag

## v0.0.0


### 21 Mar 2024

- [e00bc10](https://github.com/russmatney/log/commit/e00bc10): feat: plugin version, split out todos
- [1c7b719](https://github.com/russmatney/log/commit/1c7b719): chore: expand ci to cover more godot versions

### 20 Mar 2024

- [8500f27](https://github.com/russmatney/log/commit/8500f27): feat: add logo
- [83b633a](https://github.com/russmatney/log/commit/83b633a): readme: split out v0.1 vs v1.0 todos
- [77cebdc](https://github.com/russmatney/log/commit/77cebdc): docs: attempt to make org/github rendering work better

  > surprised the image name/captions don't work!

- [fcf7aed](https://github.com/russmatney/log/commit/fcf7aed): Create LICENSE
- [59d76e8](https://github.com/russmatney/log/commit/59d76e8): docs: readme todos update
- [134072c](https://github.com/russmatney/log/commit/134072c): feat: readme images and example.gd

  > also refactors to_pretty to use an opts dictionary instead of continuing
  > to add optional params. This should create some space for more options
  > and clean up the impl going forward.

- [1bce1eb](https://github.com/russmatney/log/commit/1bce1eb): feat: support Object.to_printable() via duck-typing

  > Any object can now opt-in to some other logged form by implementing an
  > arg-less to_printable() function.
  > 
  > I wanted something cute, but `log()` already does logarithms, and pr()
  > or pp() felt obscure for a public function.

- [537e43a](https://github.com/russmatney/log/commit/537e43a): chore: test coverage for strings
- [b900292](https://github.com/russmatney/log/commit/b900292): fix: run ci on push
- [ab2553c](https://github.com/russmatney/log/commit/ab2553c): ci: initial gdunit4 github action

  > Straight outta https://mikeschulze.github.io/gdUnit4/faq/ci/

- [737f4d5](https://github.com/russmatney/log/commit/737f4d5): dep: add gd-plug-ui
- [05213c0](https://github.com/russmatney/log/commit/05213c0): feat: update gdUnit4
- [190724e](https://github.com/russmatney/log/commit/190724e): feat: install and init gd-plug

### 9 Mar 2024

- [aba54f2](https://github.com/russmatney/log/commit/aba54f2): docs: more todos/readme outline
- [c70815a](https://github.com/russmatney/log/commit/c70815a): test: quick dictionary test

  > just copy-pasting the output back into the test. aka snapshot testing?

- [ed7b0c3](https://github.com/russmatney/log/commit/ed7b0c3): chore: clean up some bits

  > Experimented with more readable bbcode output, only to learn that you
  > can just 'print' it. heh.

- [0ca946f](https://github.com/russmatney/log/commit/0ca946f): test: impl some basic tests

### 16 Feb 2024

- [64c0d23](https://github.com/russmatney/log/commit/64c0d23): feat: first basic test running (and failing)
- [7b9f964](https://github.com/russmatney/log/commit/7b9f964): feat: run tests bia bb test/test-match
- [2870db0](https://github.com/russmatney/log/commit/2870db0): chore: add gdunit
- [28ebf33](https://github.com/russmatney/log/commit/28ebf33): feat: example scene
- [e6663de](https://github.com/russmatney/log/commit/e6663de): feat: pull in log impl and init plugin