#!/usr/bin/env bash

source test/init

source getopt.bash --

getopt_spec="\
cmd ...

Options:
--
f,file=file     File
d,dir=dir       Dir
c,count=num     Count
n,num=1..10     Number
b,bool          Boolean
"

getopt

is "$option_count_file" "0" \
  "--file used 0 times"

is "$option_file" "" \
  "option_file is ''"

getopt --file=test/init

is "$option_file" test/init \
  "option_file is '%want%'"

try getopt --file=test/init/xxx

has "$got" \
  "value 'test/init/xxx' file does not exist" \
  "Invalid file error msg is correct"

try getopt --count=k9

has "$got" \
  "value 'k9' is not a number" \
  "Invalid number error msg is correct"

try getopt --num=11

has "$got" \
  "value '11' is not in the range" \
  "Number not in range error msg is correct"

done-testing

# vim: ft=sh:
