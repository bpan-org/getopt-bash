#!/usr/bin/env bash

source test/init

source getopt.bash --

spec="\
Options:
--
n,name=         The name
v               Verbose
this?           Flag or value
that            Flag
"

getopt -n alice --name bob --name=chuck <<<"$spec"

is "${option_name[*]}" \
  "alice bob chuck" \
  "Parsed multiple names in array"

is "$option_count_name" 3 "--name used 3 times"

getopt -vvv <<<"$spec"

is "$option_v" true "option_v is true"
is "$option_count_v" 3 "option_count_v is 3"

getopt --this=42 --that <<<"$spec"

is "$option_this" 42 "option_this is 42"
is "$option_that" true "option_that is true"

getopt --this=42 --this=43 <<<"$spec"

is "$option_this" 42 "option_this is 42"
is "$option_count_this" 2 "option_count_this is 2"

getopt --this --this=43 <<<"$spec"

is "$option_this" true "option_this is true"
is "$option_count_this" 2 "option_count_this is 2"

done-testing 10

# vim: ft=sh:
