## Why

`skey config` currently only tracks namespace-level state. There is no way to associate an SSH key with a specific host — meaning `~/.ssh/config` can't be populated with real `Host` entries. This change adds per-key config state so that each key can be wired to a hostname, making `skey` a complete SSH config manager. A `^M` (carriage return) bug in generated output is also fixed.

## What Changes

- Add `skey config` interactive flow for a specific key: prompts for `<namespace>` and `<key-name>`, then collects SSH connection fields
- Store per-key state at `~/.ssh/<namespace>/<key-name>/.config.yaml` with: `hostname`, `alias` (auto-derived as `<namespace>-<key-name>`), `user`, `port`, `identity_file`, and other common SSH fields (all except `hostname` have sensible defaults)
- Regenerate `~/.ssh/config` managed block from all per-key `.config.yaml` files, producing real `Host` entries
- Fix `^M` carriage return characters introduced by heredoc/printf in the current script

## Capabilities

### New Capabilities

- `skey-key-config`: Per-key config state management — interactive collection, YAML storage at `~/.ssh/<namespace>/<key-name>/.config.yaml`, and SSH config block generation from key configs

### Modified Capabilities

- `skey-config`: Config subcommand now also takes an optional key name to target a specific key; SSH config block regenerated from per-key configs instead of namespace-level includes

## Impact

- `gtools/ssh-key-manager/skey.sh` — new per-key config flow, updated `ssh_config_build_block` to read per-key YAMLs, `^M` fix
- `gtools/ssh-key-manager/README.md` — document per-key config usage
