# skey

Interactive TUI for managing SSH keys, built with bash + [gum](https://github.com/charmbracelet/gum).

Keys are created at `~/.ssh/<namespace>/<key-name>/id_ed25519`.
Namespace configs are tracked in `~/.ssh/.skey.yaml` and wired into `~/.ssh/config` automatically.

## Install

**Via curl:**

```bash
curl -fsSL https://raw.githubusercontent.com/OppOops/my-tools/refs/heads/main/gtools/ssh-key-manager/install.sh | bash
```

**From this repo:**

```bash
./install.sh                  # installs to ~/.local/bin/skey
./install.sh /usr/local/bin   # installs system-wide (may need sudo)
```

Then run as:

```bash
skey
```

## Requirements

- [`gum`](https://github.com/charmbracelet/gum) — `brew install gum`
- `ssh-keygen` (standard on most systems)

## Usage

### Create a key

```bash
# Fully interactive (prompts for namespace + key name)
skey create

# Key name as argument, namespace prompt pre-filled with "work"
skey create github

# Explicit namespace via flag (skips prompt)
skey create -n personal github

# With comment
skey create -n work github -C "work laptop"

# Override default namespace via env var
GTOOLS_SSH_NAMESPACE=clients skey create acme
```

### Configure a namespace

```bash
# Set up namespace config and update ~/.ssh/config
skey config

# For a specific namespace
skey config -n personal
```

This creates `~/.ssh/<namespace>/.skey-config.yaml` and adds an `Include` entry for it inside a managed block in `~/.ssh/config`.

## Options

### create

| Flag | Description |
|---|---|
| `-n <namespace>` | Set namespace (overrides env var and default) |
| `-C <comment>` | Add a comment to the key (forwarded to `ssh-keygen`) |

### config

| Flag | Description |
|---|---|
| `-n <namespace>` | Namespace to configure (overrides env var and default) |

## Configuration

Set `GTOOLS_SSH_NAMESPACE` in your shell profile to change the default namespace (defaults to `work`):

```bash
export GTOOLS_SSH_NAMESPACE=personal
```
