#!/usr/bin/env bash

source test/init

source getopt.bash --

spec="\
Options:
--
f,foo-bar       Foo bar
s,some-thing=   Some thing
"

getopt --foo-bar --some-thing=cool <<<"$spec"

is "$option_foo_bar" \
  true \
  "Boolean options with dash in name work"

is "$option_some_thing" \
  cool \
  "Value options with dash in name work"

getopt -f -s stupid <<<"$spec"

is "$option_foo_bar" \
  true \
  "Short boolean options with dash in long name work"

is "$option_some_thing" \
  stupid \
  "Short value options with dash in long name work"

done-testing

# vim: ft=sh:
