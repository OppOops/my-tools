# ssh-key-manager

Interactive TUI for creating SSH keys, built with bash + [gum](https://github.com/charmbracelet/gum).

Keys are created at `~/.ssh/<namespace>/<key-name>/id_ed25519`.

## Install

**From this repo:**

```bash
./install.sh                  # installs to ~/.local/bin/ssh-key-manager
./install.sh /usr/local/bin   # installs system-wide (may need sudo)
```

Then run as:

```bash
ssh-key-manager
```

## Requirements

- [`gum`](https://github.com/charmbracelet/gum) — `brew install gum`
- `ssh-keygen` (standard on most systems)

## Usage

```bash
# Fully interactive (prompts for namespace + key name)
./ssh-key-manager.sh

# Key name as argument, namespace prompt pre-filled with "work"
./ssh-key-manager.sh github

# Explicit namespace via flag (skips prompt)
./ssh-key-manager.sh -n personal github

# With comment
./ssh-key-manager.sh -n work github -C "work laptop"

# Override default namespace via env var
GTOOLS_SSH_NAMESPACE=clients ./ssh-key-manager.sh acme
```

## Options

| Flag | Description |
|---|---|
| `-n <namespace>` | Set namespace (overrides env var and default) |
| `-C <comment>` | Add a comment to the key (forwarded to `ssh-keygen`) |

## Configuration

Set `GTOOLS_SSH_NAMESPACE` in your shell profile to change the default namespace (defaults to `work`):

```bash
export GTOOLS_SSH_NAMESPACE=personal
```
