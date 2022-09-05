#!/usr/bin/env bash

source test/init

source getopt.bash --

spec="\
Options:
--
f,file=+        File path
n,name=+str     The name
"

try getopt foo <<<"$spec"
test() { has "$got" "$1" "'$cmd' output has '%want'"; }
test "* Option '--file=…' is required"
test "* Option '--name=…' is required"
test "[getopt] Error: Missing required options"

try getopt -f foo -n name <<<"$spec"
is "$got" '' "'$cmd' is ok"

done-testing 4

# vim: ft=sh:
