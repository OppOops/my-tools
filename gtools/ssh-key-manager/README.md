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

### Show workspace status

```bash
skey status
```

Shows all registered namespaces and their keys, any unregistered namespace directories, and whether `~/.ssh/config` is in sync.

### Configure a namespace or key

```bash
# Register a namespace and update ~/.ssh/config
skey config

# For a specific namespace
skey config -n personal

# Configure a specific key — runs SSH connection wizard
skey config -n work github
```

When a key name is given, `skey config` prompts for the SSH connection details (`hostname`, `user`, `port`, etc.) and stores them in `~/.ssh/<namespace>/<key-name>/.config.yaml`. The `~/.ssh/config` managed block is then regenerated with real `Host` entries:

```
Host work-github
  HostName github.com
  User git
  Port 22
  IdentityFile ~/.ssh/work/github/id_ed25519
  ForwardAgent no
  ServerAliveInterval 60
```

The `Host` alias is auto-derived as `<namespace>-<key-name>` to avoid conflicts.

## Options

### create

| Flag | Description |
|---|---|
| `-n <namespace>` | Set namespace (overrides env var and default) |
| `-C <comment>` | Add a comment to the key (forwarded to `ssh-keygen`) |

### config

| Flag/Arg | Description |
|---|---|
| `-n <namespace>` | Namespace to configure (overrides env var and default) |
| `[key-name]` | If given, run per-key SSH config wizard |

## Configuration

Set `GTOOLS_SSH_NAMESPACE` in your shell profile to change the default namespace (defaults to `work`):

```bash
export GTOOLS_SSH_NAMESPACE=personal
```
