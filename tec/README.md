# tec

tec-managed shell toolchain initialization.

<!--- Tree block injection -->
    └── @config
        └── zsh
            └── rc.d
                └── 90_tec_init.zshrc 	# initialize tec-managed shell toolchain late

This package uses the zsh mixin pattern. It contributes a late interactive zsh snippet into the shared zsh `rc.d` directory:

```text
tec/@config/zsh/rc.d/90_tec_init.zshrc
```

tec/dev/devx shell initialization should run late, so this package uses the `90_*` range.

## Installation

Stow this package after the base `zsh` package:

```bash
dotstow zsh
dotstow tec
```
