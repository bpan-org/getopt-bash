#!/usr/bin/env bash

source test/init

source getopt.bash --

spec="\
Options:
--
b,bool      Boolean flag option
v,value=    Value option
d,dual?     Dual bool/value option
"

getopt <<<"$spec"

is "$option_bool" false \
  "unused boolean option defaults to false"

is "$option_count_bool" 0 \
  "unused boolean option count is 0"

is "$option_value" '' \
  "unused value option defaults to ''"

is "$option_count_value" 0 \
  "unused value option count is 0"

is "${option_dual-}" '' \
  "unused dual option defaults to ''"

is "$option_count_value" 0 \
  "unused dual option count is 0"

done-testing

# vim: ft=sh:
