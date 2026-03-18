## Why

`ssh-key-manager` is verbose and single-purpose. Evolving it into `skey` with a subcommand structure makes it composable for future operations, and a `config` subcommand closes the gap between creating keys and wiring them into `~/.ssh/config`.

## What Changes

- **BREAKING** Rename installed binary from `ssh-key-manager` to `skey` via install script
- **BREAKING** Key creation is now `skey create [flags] [key-name]` (was the default behavior)
- Add `skey config` subcommand: generates a per-namespace YAML config at a target folder and applies it to `~/.ssh/config` inside a managed section
- Introduce `~/.ssh/.skey.yaml` as the global state file tracking known namespaces and their config paths
- Update `gtools/ssh-key-manager/install.sh` to install as `skey`
- Update README to reflect new command name and subcommand structure

## Capabilities

### New Capabilities

- `skey-subcommands`: Subcommand dispatch (`create`, `config`, `help`) as the new entry point for the script
- `skey-config`: Config generation — write a YAML file to a target folder and maintain a generated section in `~/.ssh/config`
- `skey-state`: Global state file `~/.ssh/.skey.yaml` tracking registered namespaces and their associated config paths

### Modified Capabilities

- `ssh-key-manager`: `create` subcommand wraps existing key creation; binary renamed to `skey`

## Impact

- `gtools/ssh-key-manager/ssh-key-manager.sh` — refactored into subcommand structure, renamed via install
- `gtools/ssh-key-manager/install.sh` — installs as `skey` instead of `ssh-key-manager`
- `gtools/ssh-key-manager/README.md` — updated for new command name and usage
- New runtime side-effect: writes/updates `~/.ssh/config` and `~/.ssh/.skey.yaml`
- External dependency: `yq` or inline YAML generation (bash only, no extra deps preferred)
