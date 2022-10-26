#!/usr/bin/env bash

source test/init

source getopt.bash --

spec="\
Options:
--
f,file?   File path
"

unset option_file
getopt --file foo <<<"$spec"
is "$option_file" true \
  "Dual option used as flag returns true"

unset option_file
getopt foo <<<"$spec"
is "${option_file-}" '' \
  "Dual option defaults to empty string"

unset option_file
getopt --file=this.txt foo <<<"$spec"
is "$option_file" this.txt \
  "Dual used for value returns the string"

done-testing

# vim: ft=sh:
