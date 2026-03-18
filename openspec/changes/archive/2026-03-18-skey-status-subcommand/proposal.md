## Why

After creating keys and configuring namespaces with `skey`, there's no way to see what's been set up without manually inspecting `~/.ssh/`. A `skey status` subcommand provides an at-a-glance overview of all namespaces, their keys, and `~/.ssh/config` sync state.

## What Changes

- Add `skey status` subcommand displaying a TUI overview of the current SSH workspace
- Show all registered namespaces from `~/.ssh/.skey.yaml`
- For each namespace, list keys found in `~/.ssh/<namespace>/`
- Indicate whether `~/.ssh/config` has the managed block and is up to date
- Register `status` in `cmd_help` usage output

## Capabilities

### New Capabilities

- `skey-status`: Status overview subcommand — namespaces, keys per namespace, SSH config sync state

### Modified Capabilities

_(none)_

## Impact

- `gtools/ssh-key-manager/skey.sh` — new `cmd_status` function + router entry
- `gtools/ssh-key-manager/README.md` — document `skey status`
