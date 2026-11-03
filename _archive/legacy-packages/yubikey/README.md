# YubiKey

Configuration for YubiKey helper utilities.

## Installation

To get desktop notifications when your YubiKey is waiting for a touch, install and enable `yubikey-touch-detector`:

```bash
# Install the package
sudo apt install yubikey-touch-detector

# Enable and start the systemd user service & socket
systemctl --user daemon-reload
systemctl --user enable --now yubikey-touch-detector.socket
systemctl --user enable --now yubikey-touch-detector.service
```

<!--- Tree block injection -->
    └── @config
        └── yubikey-touch-detector
            └── service.conf 	# yubikey-touch-detector configuration to enable libnotify desktop prompts

