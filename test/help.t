#!/usr/bin/env bash

source test/init

source getopt.bash

want="\
usage:   foo <options...>

    See 'man foo' for more help.

    Options:

    -b, --bar             Bar bar bar
    -q, --quux ...        Quux quux

    --xxx                 Xxx xxx
    --yyy ...             Yyy yyy"

got=$(getopt <<<"$spec1")
is "$got" "$want" "'getopt' help output is correct"
got=$(getopt -h <<<"$spec1")
is "$got" "$want" "'getopt -h' help output is correct"
got=$(getopt --help <<<"$spec1")
is "$got" "$want" "'getopt --help' help output is correct"

done-testing 3

# vim: ft=sh:
