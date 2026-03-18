## 1. Rename and Restructure Script

- [x] 1.1 Rename `ssh-key-manager.sh` to `skey.sh`
- [x] 1.2 Add subcommand router (`case "$1"`) dispatching to `cmd_create`, `cmd_config`, `cmd_help`
- [x] 1.3 Wrap existing key creation logic into `cmd_create` function
- [x] 1.4 Implement `cmd_help` printing usage for all subcommands and flags
- [x] 1.5 Update `install.sh` to install binary as `skey` instead of `ssh-key-manager`

## 2. Global State File (skey-state)

- [x] 2.1 Implement `state_init` — create `~/.ssh/.skey.yaml` with empty `namespaces` map if absent, chmod 600
- [x] 2.2 Implement `state_get_config_path <namespace>` — grep `.skey.yaml` to return config path for a namespace (empty if not found)
- [x] 2.3 Implement `state_register <namespace> <config-path>` — append namespace entry to `.skey.yaml` if not already present

## 3. skey config Subcommand

- [x] 3.1 Implement `cmd_config` function skeleton with namespace resolution (same `-n` / env var / default logic as `cmd_create`)
- [x] 3.2 Add namespace prompt via `gum input --value "$NAMESPACE"` when no `-n` flag given
- [x] 3.3 Validate namespace with `^[a-zA-Z0-9_-]+$`; exit 1 if invalid
- [x] 3.4 Ensure `~/.ssh/<namespace>/` exists (create with chmod 700 if absent)
- [x] 3.5 Create `~/.ssh/<namespace>/.skey-config.yaml` if absent with default YAML structure (namespace name + empty hosts list)
- [x] 3.6 Call `state_init` then `state_register` to record the namespace in `~/.ssh/.skey.yaml`
- [x] 3.7 Implement `ssh_config_update` — read `~/.ssh/config`, replace or append the managed block bounded by sentinel lines
- [x] 3.8 Build managed block content: one `Include` line per namespace registered in `.skey.yaml`
- [x] 3.9 Call `ssh_config_update` from `cmd_config` after state registration
- [x] 3.10 Display success message via `gum style` showing config path and updated `~/.ssh/config`

## 4. README Update

- [x] 4.1 Update README command name from `ssh-key-manager` to `skey` throughout
- [x] 4.2 Add `skey create` and `skey config` usage examples
- [x] 4.3 Update curl install URL comment to reflect binary name change
