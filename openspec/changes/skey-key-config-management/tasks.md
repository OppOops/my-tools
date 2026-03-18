## 1. Fix ^M Carriage Returns

- [x] 1.1 Audit all `echo`, string concatenation with `$'\n'`, and `gum style` captures in `skey.sh` — replace with `printf '%s\n'` and pipe captured values through `tr -d '\r'`
- [x] 1.2 Ensure `ssh_config_update` writes via `printf` without CRs

## 2. Per-Key Config Wizard

- [x] 2.1 Update `cmd_config` argument parsing to accept an optional positional `<key-name>` argument after flags
- [x] 2.2 If key name given and `~/.ssh/<namespace>/<key-name>/.config.yaml` already exists, skip wizard and go directly to SSH config regeneration
- [x] 2.3 Prompt for `hostname` via `gum input` (no default, required — re-prompt if empty)
- [x] 2.4 Prompt for `user` via `gum input --value "$USER"`
- [x] 2.5 Prompt for `port` via `gum input --value "22"`
- [x] 2.6 Prompt for `forward_agent` via `gum choose "false" "true"`
- [x] 2.7 Prompt for `server_alive_interval` via `gum input --value "60"`

## 3. Per-Key Config YAML Write

- [x] 3.1 Auto-derive `alias` as `<namespace>-<key-name>`
- [x] 3.2 Auto-derive `identity_file` as `~/.ssh/<namespace>/<key-name>/id_ed25519`
- [x] 3.3 Write `~/.ssh/<namespace>/<key-name>/.config.yaml` using `printf` with all seven fields; strip `\r` from any captured values

## 4. SSH Config Block Regeneration

- [x] 4.1 Update `ssh_config_build_block` to walk registered namespaces in `.skey.yaml` and collect all `.config.yaml` files under `~/.ssh/<namespace>/*/`
- [x] 4.2 Render each `.config.yaml` as a `Host <alias>` block with `HostName`, `User`, `Port`, `IdentityFile`, `ForwardAgent`, `ServerAliveInterval` fields
- [x] 4.3 Ensure rendered block has no `\r` characters before writing to `~/.ssh/config`

## 5. Help and README

- [x] 5.1 Update `cmd_help` to show `config [-n <ns>] [key-name]` signature
- [x] 5.2 Update README with per-key config usage example
