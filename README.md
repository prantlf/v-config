# config

Reads a configuration file into a configuration struct.

Uses [prantlf.json] and [prantlf.yaml]. Can be combined with [prantlf.cargs] to override selected options from the command-line.

## Synopsis

Specify usage description and version of the command-line tool. Declare a structure with all command-line options. Import the command-line parser and parse the options and arguments:

```go
import prantlf.cargs { Input, parse_to }
import prantlf.config { find_config_file, read_config }

mut opts := if config_file := find_config_file('.', [
  '.newchanges.json',
  '.newchanges.yml',
  '.newchanges.yaml',
], 10, true) {
  read_config[Opts](config_file)!
} else {
  &Opts{}
}
cmds := parse_to(usage, Input{ version: version }, mut opts)!
```

## Installation

You can install this package either from [VPM] or from GitHub:

```txt
v install prantlf.config
v install --git https://github.com/prantlf/v-config
```

## API

The following functions are exported:

### find_config_file(start_dir string, names []string, depth int, user bool) ?string

Searches for files or directories with the specified names. The search starts in the directory `start_dir` and continues to a parent directory as many times as is the number `depth`. The dept 0 means searching only the directory `start_dir`. If the flg `user` is true, it will look to the home directory of the current user too.

Files and directories will be matched with the specified names in ghe order of the names in the array. The first one matching will cause the method return the absolute path to the found file. If no file or directory with the specified names can be found, `none` will be returned.

```go
config_file := find_config_file('.', [
  '.newchanges.json',
  '.newchanges.yml',
  '.newchanges.yaml',
], 10, true)
```

### read_config[T](file string) !T

Reads the file and deserialises its content from the format assumed by the file extension to the specified generic struct.

| Extension | Format                 |
|:----------|:-----------------------|
| `.json`   | [JSON]/[JSONC]/[JSON5] |
| `.yml`    | [YAML]                 |
| `.yaml`   | [YAML]                 |

```go
opts := read_config[Opts]('~/.newchanges.json')!
```

## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style. Lint and test your code.

## License

Copyright (c) 2023 Ferdinand Prantl

Licensed under the MIT license.

[VPM]: https://vpm.vlang.io/packages/prantlf.config
[JSON]: https://www.json.org/
[JSONC]: https://changelog.com/news/jsonc-is-a-superset-of-json-which-supports-comments-6LwR
[JSON5]: https://spec.json5.org/
[YAML]: https://yaml.org/
[prantlf.cargs]: https://github/com//prantlf/v-cargs
[prantlf.json]: https://github.com/prantlf/v-json
[prantlf.yaml]: https://github.com/prantlf/v-yaml
