## Why

`skey git-remote` currently resolves the alias to use by matching the remote hostname against all registered keys. This works when there's a hostname match, but gives no way to directly specify which workspace and key to apply — useful when no `.config.yaml` exists for that hostname yet, or when the user wants to force a specific key. Adding explicit `<workspace> <key-name>` arguments with a picker fallback makes the command more direct and discoverable.

## What Changes

- `skey git-remote` accepts two optional positional arguments: `<workspace>` and `<key-name>`
- When neither is provided, `gum choose` presents all `<workspace>/<key-name>` pairs from the registered workspace, replacing the hostname-lookup flow
- When only `<workspace>` is provided, `gum choose` narrows the list to keys in that workspace
- When both are provided, they are used directly — no picker shown
- The alias is derived from the selected workspace+key-name (format: `<workspace>-<key-name>`) and used to rewrite the remote URL, bypassing hostname lookup
- Hostname lookup remains as the fallback when no positional args are given and the picker is cancelled or workspace is empty

## Capabilities

### New Capabilities
- none

### Modified Capabilities
- `skey-git-remote`: New `<workspace> <key-name>` positional arguments with picker fallback when not provided; alias derived from args instead of hostname lookup when args are given

## Impact

- `cmd_git_remote` in `skey.sh` — argument parsing and alias-resolution logic
- `cmd_help` entry for `git-remote` — update usage line
- `openspec/specs/skey-git-remote/spec.md` — delta spec for modified requirements
