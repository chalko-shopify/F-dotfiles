# Git

User-level Git configuration.

<!--- Tree block injection -->
    └── .gitconfig 	# user-level Git configuration

This package currently preserves the working `~/.gitconfig` as the first step of a slow migration.

It includes Shopify/dev-managed Git configuration from `~/.config/dev/gitconfig`, which is managed separately by dev/tec tooling and should not be copied into this package without careful review.

## Installation

Back up any existing `~/.gitconfig`, then stow this package:

```bash
dotstow git
```
