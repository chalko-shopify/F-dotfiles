# iTerm2

iTerm2-specific shell integration and terminal configuration.

<!--- Tree block injection -->
    └── @config
        └── @Darwin
            └── zsh
                └── rc.d
                    └── 50_iterm_shell_integration.zshrc 	# source iTerm2 shell integration on macOS

This package uses the zsh mixin pattern. It contributes a macOS-only interactive zsh snippet into the shared zsh `rc.d` directory:

```text
iterm/@config/@Darwin/zsh/rc.d/50_iterm_shell_integration.zshrc
```

## Installation

Stow this package after the base `zsh` package:

```bash
dotstow zsh
dotstow iterm
```
