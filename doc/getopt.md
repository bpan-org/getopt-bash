getopt-bash
===========

Declarative Getopt Parser for Bash


# Synopsis

```bash
#!/bin/bash

source getopt.bash "\
getopt_default=(--help)

my-app <options...> <arguents...>

See 'man my-app' for more help.

Options:
--
b,bar       Bar bar bar
q,quux=     Quux quux

xxx         Xxx xxx
yyy=        Yyy yyy

help        Show help
version     Print my-app version
"

getopt "$@"
set -- "${args[@]}"

if $option_bar || $option_xxx; then
  echo 'Options:'
  echo "quux = $option_quux"
  echo "yyy = $option_yyy"
  echo 'Arguments:'
  printf "- %s\n" "$@"
fi
```


# Description

Git has a little known, but very cool getopt parser built in.
The Git command is:
```bash
git rev-parse --parseopt -- <command-line-args> \
  <<<"<special-format-getopt-spec-text>"
```

You pipe in a special format that looks like a help text describing the
command.
If you ask for `--help` (or the parser fails to parse the options), it actually
will print a slightly reformatted version of that spec.

This library makes that Git parser even more powerful and easy to use.


# Parlance

* options (or opts)

  Options are the parameters like `-h`, `--help`, `-f <file>`, `--file <file>`
  or `--file=<file>.
  Note that option names are case sensitive.
  ie `-f` and `-F` are diffent options.

* arguments (or args)

  Arguments are the (zero or more) strings that (usually) follow the options.

* long option

  An option of the form `--name`.
  Two dashes and two or more letters in the name.
  An `=` or a space may be used to separate the option from its value.
  ie `--file=abc.txt` or `--file abc.txt`.

* short option

  An option of the form `-n`.
  A single dash and a single character for the name.
  If the option has a value, it is separated by a space: `-f abc.txt`.

* flag option

  Flag options never have a value parameter.
  The values returned by getopt-bash are `false` (default if the option is not
  present) and `true` if the option *is* present.

* value option

  Value options always have a value parameter.
  This getopt-bash library returns the value specified or the empty string if
  it is not present in the parsed parameters.

* dual option

  A dual option can be used alone like a flag option, or with a value.


# Usage

The `getopt-bash` library provides a single file `lib/getopt.bash`.
If you `source getopt.bash` it provides a function called `getopt`.
The `getopt` function expects a specially formatted spec string in its STDIN
and the arguments you want to parse, passed in as arguments to the function.

The `getopt` function will (by default) set each option in a variable called
`option_<option-name>` and put any arguments into an array variable called
`args`.

The declared option variables will default to `false` for flag options and `''`
for value options.
Actually the default for a value option is an empty array, but when used in a
scalar context it will return the first value or `''` if the array is empty.

If a value option is specified multiple times, the option variable will be an
array with all the values in the order they were used.

The variable `option_count_<name>` will be set to the number of times that
option was used.

If a flag option is specified multiple times, the value will be `true`.
If a dual option is specified multiple times, the first value will be used.
The `option_count_<name>` variable will still be accurate though.

Here's an example:
```bash
getopt_default=--help \
  getopt "$@" <<<"$spec_string"
echo "The '--foo=' option is '$option_foo'"
echo "The '--bar' option was used $option_count_bar times.
echo "The remaining arguments are '${args[*]}'"
```

NOTE: Bash has a builtin `getopt` command that doesn't do nearly as much.
If you need to use the builtin in combination with this library, just use this
command: `builtin getopt ...` for the builtin version.


## The getopt Spec String Format

To get good at using getopt-bash you should run `git help rev-parse`, search
for `^PARSEOPT` and read that entire section.
The getopt-bash function uses `git rev-parse --parseopt` under the hood, but
does a bunch of extra pre-processing and post-processing to make things really
nice and simple.

The options section of the spec has these various combinations:
```
The options with `str` and `num` are enforced by getopt-bash
--
f,file=         Description of a value option (both short and long)
help            Description of a flag option (long only)
Q?              Description of a dual option (short only)

color=str       Value must be a string
verbose?num     Value (if present) must be a number
```

The getopt-bash library adds additional features to the spec options syntax:
```
input=+         This option is required
size=+num       Required and must be a number
```

In `git rev-parse --parseopt` there are 4 flag characters: '* = ? !`.
The getopt-bash library adds:

* `+`

  Option is required.
  This only makes sense for value options.

In `git rev-parse` you can specify a hint word to indicate in the help text
what type of value (`num`, `str`, etc) is expected for a value option.

Some hints are enforced and some are suggestions.

By default, getopt-bash will enforce the following hints:

* `str`

  Value should be a string.

* `num`

  Value should be a number.

* `1..10`

  Value should be a number in the range 1-10.

* `file`

  Value should be a file that exists.

* `dir`

  Value should be a directory the exists.

* `path`

  Value should be the path of a file or directory that exists.

* `yyyy-mm-dd_HH:MM:SS`

  Dates and times can be specified in any layout containing the strings:
  `yyyy`, `yy`, `mm`, `dd`, `HH`, `MM`, `SS`.
  Underscores are used for space characters.
  All other characters represent themselves.

* `/.../`

  A hint enclosed in slash characters is a Bash regex to match.


## Configuration

The `getopt` function has sensible defaults but it is also highly configurable.
There are a number of `getopt_...` variables you can use.
These variables can be set directly or by adding lines like:

```
getopt_default=(--help)
getopt_args=my_args
```

to the beginning of your spec text.

The currently available option variables are:

* `getopt_default=...` (default is `''`)

  If no arguments were used, then use these.
  Multiple default arguments can be specified as an array:
  `getopt_default=(--foo --bar)`.
  This option is most commonly set to `getopt_default=--help` (when
  appropriate).

* `getopt_prefix=...` (default is `option_`)

  The prefix for the getopt option variables where values are stored.

* `getopt_args=...` (default is `args)

  Name of the array variable to store the arguments found.


# License and Copyright

Copyright 2020-2022. Ingy döt Net <ingy@ingy.net>.

getopt-bash is released under the MIT license.

See the file License for more details.
