## Why

`skey config` currently requires knowing namespace and key name upfront. Adding a workspace picker makes it discoverable — users can browse existing keys and configure them without typing. The new `skey git-remote` subcommand closes the loop between SSH key aliases and Git, replacing a repo's remote URL with one that uses the skey-managed `Host` alias so `ssh work-github` routing applies automatically.

## What Changes

- `skey config` with no arguments now presents a `gum choose` picker of all namespace/key combinations from the workspace; selected entry is passed directly to the existing per-key config wizard. SSH config sync still runs after.
- Add `skey git-remote` subcommand: replaces the current git remote URL (default: `origin`) by substituting the hostname with the skey alias. Skips silently if not in a git directory or remote URL is unset.

## Capabilities

### New Capabilities

- `skey-config-picker`: Workspace-aware `skey config` selection — when no namespace/key given, present `gum choose` list of all known keys
- `skey-git-remote`: Git remote URL rewriter — replaces hostname in remote URL with skey alias; skips gracefully if preconditions not met

### Modified Capabilities

_(none — existing `cmd_config` argument path unchanged when args are provided)_

## Impact

- `gtools/ssh-key-manager/skey.sh` — `cmd_config` picker path + new `cmd_git_remote` function + router entry
- `gtools/ssh-key-manager/README.md` — document picker behaviour and `skey git-remote`
