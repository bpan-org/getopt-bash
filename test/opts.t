#!/usr/bin/env bash

source test/init

source getopt.bash

set -- -b --yyy=okie

getopt "$@" < test/spec1.txt

is "$option_bar" "true" "Short flag option is set correct"
is "${option_quux-}" "" "Value option is empty by default"
is "$option_xxx" "false" "Long flag option has default correct"
is "$option_yyy" "okie" "Long value option works correctly"

done-testing 4

# vim: ft=sh:
