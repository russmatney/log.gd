# CHANGELOG


## Unreleased


### 21 Mar 2024

- docs: changelog formatting - bodies as comments ([30eb286](https://github.com/russmatney/log/commit/30eb286))

  > I'm hopeful this ends up being more readable.

- feat: generating initial changelog ([7e210ae](https://github.com/russmatney/log/commit/7e210ae))
- wip: bb code gathering commits per tag ([f3be3be](https://github.com/russmatney/log/commit/f3be3be))

## v0.0.0


### 21 Mar 2024

- feat: plugin version, split out todos ([e00bc10](https://github.com/russmatney/log/commit/e00bc10))
- chore: expand ci to cover more godot versions ([1c7b719](https://github.com/russmatney/log/commit/1c7b719))

### 20 Mar 2024

- feat: add logo ([8500f27](https://github.com/russmatney/log/commit/8500f27))
- readme: split out v0.1 vs v1.0 todos ([83b633a](https://github.com/russmatney/log/commit/83b633a))
- docs: attempt to make org/github rendering work better ([77cebdc](https://github.com/russmatney/log/commit/77cebdc))

  > surprised the image name/captions don't work!

- Create LICENSE ([fcf7aed](https://github.com/russmatney/log/commit/fcf7aed))
- docs: readme todos update ([59d76e8](https://github.com/russmatney/log/commit/59d76e8))
- feat: readme images and example.gd ([134072c](https://github.com/russmatney/log/commit/134072c))

  > also refactors to_pretty to use an opts dictionary instead of continuing
  > to add optional params. This should create some space for more options
  > and clean up the impl going forward.

- feat: support Object.to_printable() via duck-typing ([1bce1eb](https://github.com/russmatney/log/commit/1bce1eb))

  > Any object can now opt-in to some other logged form by implementing an
  > arg-less to_printable() function.
  > 
  > I wanted something cute, but `log()` already does logarithms, and pr()
  > or pp() felt obscure for a public function.

- chore: test coverage for strings ([537e43a](https://github.com/russmatney/log/commit/537e43a))
- fix: run ci on push ([b900292](https://github.com/russmatney/log/commit/b900292))
- ci: initial gdunit4 github action ([ab2553c](https://github.com/russmatney/log/commit/ab2553c))

  > Straight outta https://mikeschulze.github.io/gdUnit4/faq/ci/

- dep: add gd-plug-ui ([737f4d5](https://github.com/russmatney/log/commit/737f4d5))
- feat: update gdUnit4 ([05213c0](https://github.com/russmatney/log/commit/05213c0))
- feat: install and init gd-plug ([190724e](https://github.com/russmatney/log/commit/190724e))

### 9 Mar 2024

- docs: more todos/readme outline ([aba54f2](https://github.com/russmatney/log/commit/aba54f2))
- test: quick dictionary test ([c70815a](https://github.com/russmatney/log/commit/c70815a))

  > just copy-pasting the output back into the test. aka snapshot testing?

- chore: clean up some bits ([ed7b0c3](https://github.com/russmatney/log/commit/ed7b0c3))

  > Experimented with more readable bbcode output, only to learn that you
  > can just 'print' it. heh.

- test: impl some basic tests ([0ca946f](https://github.com/russmatney/log/commit/0ca946f))

### 16 Feb 2024

- feat: first basic test running (and failing) ([64c0d23](https://github.com/russmatney/log/commit/64c0d23))
- feat: run tests bia bb test/test-match ([7b9f964](https://github.com/russmatney/log/commit/7b9f964))
- chore: add gdunit ([2870db0](https://github.com/russmatney/log/commit/2870db0))
- feat: example scene ([28ebf33](https://github.com/russmatney/log/commit/28ebf33))
- feat: pull in log impl and init plugin ([e6663de](https://github.com/russmatney/log/commit/e6663de))