# Homebrew

Homebrew shell environment integration.

<!--- Tree block injection -->
    └── @config
        └── @Darwin
            └── zsh
                └── profile.d
                    └── 10_brew_shellenv.zprofile 	# initialize Homebrew environment on macOS login shells

This package uses the zsh mixin pattern. It contributes a macOS-only login-shell zsh snippet into the shared zsh `profile.d` directory:

```text
brew/@config/@Darwin/zsh/profile.d/10_brew_shellenv.zprofile
```

## Installation

Stow this package after the base `zsh` package:

```bash
dotstow zsh
dotstow brew
```
