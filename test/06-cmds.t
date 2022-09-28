#!/usr/bin/env bash

source test/init

source getopt.bash --

spec="\
getopt_cmds_find=true
getopt_cmds_spec=get-cmd-spec

cmd ...

Commands:

  foo       Foo
  bar       Bar

Options:
--
this        This
that=       That
h,help      Show help
"

get-cmd-spec() (
  case $1 in
    foo) cat <<'...'
cmd foo ...

Options:
--
this        This
food        Food
...
    ;;

    bar) cat <<'...'
cmd foo ...

Options:
--
that=       That
barge       Barge
...
    ;;
  esac
)

getopt --this foo --food <<<"$spec"

is "$cmd" foo \
  "\$cmd is 'foo'"

is "$option_this" true \
  "option_this is 'true'"

is "$option_food" true \
  "option_food is 'true'"

getopt --this foo --this <<<"$spec"

is "$option_this" true \
  "option_this is 'true'"

# XXX Should this be 1 or 2?
# is "$option_count_this" 2 \
#   "option_count_this is 2"

getopt --that 'ice cold' bar --barge this that <<<"$spec"

is "$cmd" bar \
  "\$cmd is 'bar'"

is "$option_that" 'ice cold' \
  "option_that is 'ice cold'"

is "$option_barge" true \
  "option_barge is 'true'"

is "${#args[*]}" 2 \
  "There are 2 arguments"

is "${args[*]}" "this that" \
  "The arguments are (this that)"

done-testing

# vim: ft=sh:
