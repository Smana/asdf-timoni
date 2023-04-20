<div align="center">

# asdf-timoni [![Build](https://github.com/Smana/asdf-timoni/actions/workflows/build.yml/badge.svg)](https://github.com/Smana/asdf-timoni/actions/workflows/build.yml) [![Lint](https://github.com/Smana/asdf-timoni/actions/workflows/lint.yml/badge.svg)](https://github.com/Smana/asdf-timoni/actions/workflows/lint.yml)


[timoni](https://timoni.sh/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Contents](#contents)
- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add timoni
# or
asdf plugin add timoni https://github.com/Smana/asdf-timoni.git
```

timoni:

```shell
# Show all installable versions
asdf list-all timoni

# Install specific version
asdf install timoni latest

# Set a version globally (on your ~/.tool-versions file)
asdf global timoni latest

# Now timoni commands are available
timoni --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/Smana/asdf-timoni/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Smaine Kahlouch](https://github.com/Smana/)
