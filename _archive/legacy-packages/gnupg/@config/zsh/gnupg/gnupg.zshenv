# gnupg.zshenv: GnuPG environment variables and SSH socket setup

# Configure SSH to use gpg-agent socket
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket 2>/dev/null || echo "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/gnupg/S.gpg-agent.ssh")
