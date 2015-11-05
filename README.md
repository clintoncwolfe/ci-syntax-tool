# CI Syntax Tool

## Overview

Checks various source file types for syntax errors, and formats the results in a flexible way.

## Command Line Options

| Short | Long | Description |
|-------|------|-------------|
| -V    | --version | Show ci-syntax-tool version |
| -h    | --help    | Show this help message |
| -l    | --lang LANG| Select this language for checking.  Repeatable.  Default, all languages.|
|       | --list-languages | List available languages and exit |
| -f    | --format FORMAT  | Use this format for output.  Repeatable, but if repeated, must have an equal number of --output options.|
| -o    | --output PATH    | Write formatted output to this location.  Use "-" to represent STDOUT.  Defaults to STDOUT if zero or one --format option used.  Repeatable with an equal number of --format options.'|
|       | --list-formats   | List available formats and exit.|
| -r    | --require RUBYFILE | Load additional Ruby code, perhaps for a custom language or format.  Repeatable. |
| -d    | --debug | Provide debug-level output to STDOUT.|

## Exit codes

### 0

Success - no files contained errors, or an option was given that did not involve a scan.

### 1

At least one file contained an error.

### 2

Reserved.

### 3

All usage errors related to selecting or loading a Language plugin.  See STDERR for details, and possibly add --debug.

### 4

All usage errors related to selecting or loading a Format plugin.  See STDERR for details, and possibly add --debug.

### 5

All usage errors related to the --require option.  See STDERR for details, and possibly add --debug.

### 6

You specified a path to check that does not exist.

## Examples

### With no options

`ci-syntax-tool`

Loads all core syntax plugins, then uses their globs to match all files below the current directory, printing a report to STDOUT using the Progress format.  If any errors are seen, exit code 1, otherwise exit 0.

This might be good enough for a commit hook.

### Force a language to match a particular file

`ci-syntax-tool --lang YAML SomeYamlFile.txt

If a file doesn't have an extension that would match the usual glob, you can specify one or more filenames, bypassing the globbing mechanism.  Use --lang to keep it restricted to only the language you know you want.  Again, the default Progress format sends a report to STDOUT.

## Language Syntax Plugins

So far, we support:

### YAML

Using the ruby Psych parser.

### Adding Your Own

Extend CI::Syntax::Tool::Language::Base, and use --require to include your library.

## Output Format Plugins

So far, we support:

### Progress

The default format.  Prints a '.', '*', or 'x' for each file that is clean, has nonzero warnings, or nonzero errors, respectively, followed by a list of problematic files.

## Bugs and Defects

Perfect, AFAIK.

## Author

Clinton Wolfe

## Contributing

1. Fork it (https://github.com/omniti-labs/ci-syntax-tool)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request at (https://github.com/omniti-labs/ci-syntax-tool)
