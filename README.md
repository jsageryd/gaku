# Gaku

Gaku is an experimental
[SRS](https://en.wikipedia.org/wiki/Spaced_repetition#Software).

## Installation
1. Clone this repo.
2. Set your `$PATH` so that `bin/gaku` is accessible (or just run it from
   there). You may symlink `bin/gaku` to a desired location if preferred.

## Setup
1. Configure (see Configuration).
2. Copy one of the example decks (under `./example_decks`) to your configured
   deck root (`gaku.deck_root`).

## Usage
1. Run `gaku` (`bin/gaku`).
2. Pick a deck.
3. The front side of a card will be presented. Give your answer.
4. If card is not known, the back of the card will be presented.
5. Go to 3.

## Answer-matching mode
If a card in the deck has a `match` key, a typed out answer will be asked for
and matched against the value of the key. If the string starts and ends with
`/`, it will be treated as a regex. Regex option `i` may be specified to ignore
case, i.e. `/foo/i`.

## Command-line options
* `--deck (-d) with deck name as argument bypasses deck selection menu`
* `--stats (-s) displays statistics for specified or all decks`

## Configuration
The file `.gaku` in the root of this project contains the default configuration
and serves as an example. Configuration is sought for and loaded from the
following locations. All files found are loaded and the contents of files loaded
earlier is overridden by files loaded later.

1. `(project directory)/.gaku`
2. `/etc/gaku`
3. `{$XDG_CONFIG_DIRS}/gaku`
4. `$HOME/.gaku`
5. `$XDG_CONFIG_HOME/gaku`

* `$XDG_CONFIG_DIRS` defaults to `/etc/xdg` if not set.
* `$XDG_CONFIG_HOME` defaults to `$HOME/.config` if not set.

## Example run
    $ gaku
    Gaku 1.0.0

    Pick a deck:
      0) finnish_animals
      1) hiragana
      2) kanji
      3) swedish_table_of_elements
    > 0

    finnish_animals
    ▊▊▊▊▊▊▊▊▊▊▊▊▊▊▊▊▊▊▊▊▊▊▊▊▊▊▊▊▊▊ 0% [0/15]

    ▌ cat
    >
    ▌ kissa
    > kissa

    ▌ dog
    > koira

    ▌ horse
    >
    ▌ hevonen
    > hevonen

    ▌ giraffe
    >
    ▌ kirahvi
    > kirahvi

    ▌ cat
    > kissa

    ▌ hippopotamus
    >
    Farewell o/
    $

## Licence
Copyright (c) 2014 Johan Sageryd <j@1616.se>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
