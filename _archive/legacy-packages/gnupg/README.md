# GnuPG Configuration

This package manages GnuPG configuration files (gpg.conf, gpg-agent.conf, and scdaemon.conf).

<!--- Tree block injection -->
    ├── .gnupg
    │   ├── gpg-agent.conf 	# configuration for gpg-agent
    │   ├── gpg.conf 	# GnuPG configuration options
    │   └── scdaemon.conf 	# configuration for smartcard daemon
    └── @config
        └── zsh
            └── gnupg
                ├── gnupg.zsh 	# GnuPG interactive shell setup and TTY registration
                └── gnupg.zshenv 	# GnuPG environment variables and SSH socket setup

