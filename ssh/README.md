# SSH

SSH client configuration and selected public keys.

<!--- Tree block injection -->
    └── .ssh
        ├── config 	# SSH client configuration
        └── id_ed25519.pub

This package currently preserves the working `~/.ssh/config` and selected public key material as the first step of a slow migration.

Private keys, known hosts, agent state, sockets, and local-only overrides must not be committed.

## Installation

Back up any existing tracked target files, then stow this package:

```bash
dotstow ssh
```
