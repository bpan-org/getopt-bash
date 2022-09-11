#!/usr/bin/env bash

source test/init

source getopt.bash --

spec="\
getopt_default=--help

foo <options...>

See 'man foo' for more help.

Options:
--
b,bar       Bar bar bar
q,quux=     Quux quux

xxx         Xxx xxx
yyy=        Yyy yyy"

want="\
usage: foo <options...>

    See 'man foo' for more help.

    Options:

    -b, --bar             Bar bar bar
    -q, --quux ...        Quux quux

    --xxx                 Xxx xxx
    --yyy ...             Yyy yyy"

try getopt <<<"$spec"
is "$got" "$want" \
  "'getopt' help output is correct"

try getopt -h <<<"$spec"
is "$got" "$want" \
  "'getopt -h' help output is correct"

try getopt --help <<<"$spec"
is "$got" "$want" \
  "'getopt --help' help output is correct"

try getopt --xyz <<<"$spec"
has "$got" "$want" \
  "Help output is part of error messsage"

done-testing 4

# vim: ft=sh: