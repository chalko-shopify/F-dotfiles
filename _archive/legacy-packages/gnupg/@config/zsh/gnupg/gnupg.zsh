# gnupg.zsh: GnuPG interactive shell setup and TTY registration

# Set GPG TTY for PIN entry prompts
export GPG_TTY=$(tty)

# Update the gpg-agent with the current terminal TTY to ensure pinentry prompts work
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
