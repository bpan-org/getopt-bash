#!/usr/bin/env bash

source test/init

try source getopt.bash

has "$got" \
  "[getopt] Error: Use '--' (source getopt.bash --) if no args for source." \
  "'source getopt.bash' doesn't allow no arguments"

source getopt.bash "\
xxx
--
a,aaa     AAA
"

has "$getopt_spec" \
  "a,aaa     AAA" \
  "Variable 'getopt_spec' gets set by source"

done-testing
