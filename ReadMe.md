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

Git has a little known but very cool getopt parser built in.
The Git command is:
```bash
git rev-parse --parseopt -- <command-line-args> \
  <<<"<special-format-getopt-spec-text>"
```

You pipe in a special format that looks like a help text describing the
command.
If you ask for `--help` (or the parser fails to parse the options), it will
print a slightly reformatted version of that spec as a help message.

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

  An option of the form `--name` or `--some-thing`.
  Two dashes and two or more letters in the name.
  The names should be lowercase, start with a letter and be composed of
  letters, numbers and dash separators.
  An `=` or a space may be used to separate the option from its value.
  ie `--file=abc.txt` or `--file abc.txt`.

* short option

  An option of the form `-n` or `-F`.
  A single dash and a single character for the name.
  The character may be a lower or upper cased letter.
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

* getopt spec

  A multiline string that defines how getopt will behave.
  See "Spec Structure" below.

* getopt config

  The getopt library has a number of config variables you can set to get custom
  behavior.
  These variables can be set as part of the getopt spec at the top.
  They can also be set using normal Bash variable assignments as well.


# Usage

The `getopt-bash` package provides a single library file `lib/getopt.bash`.
If you `source getopt.bash` it provides a function called `getopt`.

The `getopt` function requires a getopt spec, and there are 3 ways to provide
it:

1. As the `getopt_spec` config variable.
2. As an argument to `source getopt.bash "$spec"`.
3. As STDIN to the `getopt` function.

The `getopt` function takes the arguments you want to parse (usually `$@`) as
its arguments.

The function will (by default) set each option in a variable called
`option_<option-name>` and put any arguments into an array variable called
`args`.

The declared option variables will default to `false` for flag options and `''`
for value options.
Actually the default for a value option is an empty array, but when used in a
scalar context it will return the first value or `''` if the array is empty.

Any remaining words (not options) are placed in the array variable `args`.

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


## Spec Structure

The `getopt` spec is a multiline string with 4 distinct sections:

1. Configuration Settings

   You can put any number of lines at the top of the spec that have the form:
   ```
   getopt_config_var=value
   ```

   These variables can be set elsewhere or not at all.
   Sometimes it is nice to put them in the spec since the spec acts as an
   overview of how the program works.

2. Usage Prose

   The first nonblank line(s) (after any config lines) is used as the `usage`
   in help or error messages.
   You should have one or more usage lines followed by a blank line.

3. Documentation and Commands

   The next section is where you put any free form documentation about how the
   command works.
   This is also where you typically put commands/descriptions if your program
   supports sub-commands.
   Like the `git` program has commands 'git clone` and `git checkout`, etc.
   This section ends with a mandatory `--` line.

4. Options Specification

   Everything after the `--` line is where the option parsing is defined in
   detail.
   It has its own very special format described in the next section.

The overall spec layout looks like:
```
getopt_default=--help
getopt_prefix=opt_

my-program <opts> <args>

Description of my-program.

Options:
--
f,file=         File to use
v,verbose       More output
```


## Options Specification

To get good at using getopt-bash you should run `git help rev-parse`, search
for `^PARSEOPT` and read that entire section.
The getopt-bash library uses `git rev-parse --parseopt` under the hood, but
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

In `git rev-parse --parseopt` there are 4 flag characters: `= ? * !`.
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

* `getopt_default=...` (default none)

  If no arguments were used, then use these.
  Multiple default arguments can be specified as an array:
  `getopt_default=(--foo --bar)`.
  This option is most commonly set to `getopt_default=--help` (when
  appropriate).

* `getopt_debug=<debug-opt>` (default is `debug`)

  Defines which option turns on `set -x` Bash debugging.
  The default is `--debug` but that only works if you've defined the `debug`
  option in your spec.
  If you don't want to support this feature then just don't define `debug` or
  set this setting to an empty string.

  Note: This kind of debugging is extremely useful in tracking down hard to
  find problems.

* `getopt_prefix=word_` (default is `option_`)

  The prefix for the getopt option variables where values are stored.

* `getopt_args=<var>` (default is `args`)

  Name of the array variable to store the arguments found.

* `getopt_cmds=(...)` (default is none)

  A list (array) of (sub-)commands that have their own options.

  See "Commands and Options" below.

* `getopt_cmds_find=...` (default is none)

  This config setting lets you define all commands that go into the
  `getopt_cmds` list in the options spec itself.

  If set to `true` it will take the first word from each line in the prose
  section that begins with spaces.

  Otherwise it is considered a regular expression to be applied to each line in
  the prose section.
  When a line matches, the first capture that is a word is added to the
  `getopt_cmds` list.

* `getopt_cmds_spec=<func-name>` (default is none)

  A callback function that writes an options spec for the `$cmd` command to
  stdout.


# Commands and Options

Some programs have their own (sub-)commands that have their own set of options.
The general usage looks like:
```
$ prog <opts> <cmd> <cmd-opts> <args>
```

The `git` program for instance, has dozens of commands, each with their own
options.
These options are separate from the git's general options that apply to all git
commands.

The getopt.bash library supports parsing these options as well.
You just need to tell `getopt` what the set of commands to look for is.
You can either set the `getopt_cmds` variable to a list of commands, or use the
`getopt_cmds_find` setting described above.

Each command needs to define its own options spec using the same spec format.
The way to tell `getopt` which spec to use is to set `getopt_cmds_spec` to the
name of a function that gets passed the command name and writes the
appropriate spec string to stdout.

When `getopt` recognizes a command it puts the command name into the global
variable `getopt_cmd`.
Then it calls the `getopt_cmds_spec` function with that command and uses the
newly returned spec to parse the remaining options.

For a real example of a program that has many commands with their own options,
see BPAN's `bpan` program.
It uses `getopt.bash` to parse everything.
The source code is [here](https://github.com/bpan-org/bpan/blob/main/bin/bpan).


# License and Copyright

Copyright 2020-2022. Ingy döt Net <ingy@ingy.net>.

getopt-bash is released under the MIT license.

See the file License for more details.
