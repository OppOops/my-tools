## Requirements

### Requirement: Workspace picker on bare skey config
When `skey config` is invoked with no namespace flag and no key-name argument, the tool SHALL build a list of all `<namespace>/<key-name>` items from the workspace and present them via `gum choose`. The selected item SHALL be used as the namespace and key-name for the per-key config wizard.

#### Scenario: Keys exist in workspace
- **WHEN** `skey config` is run with no arguments and workspace contains at least one key
- **THEN** a `gum choose` picker SHALL appear listing all `<namespace>/<key-name>` items

#### Scenario: User selects an item
- **WHEN** the user selects `work/github` from the picker
- **THEN** the per-key config wizard SHALL run for namespace `work` and key `github`

#### Scenario: No keys found in workspace
- **WHEN** `skey config` is run with no arguments and no keys exist under any registered namespace
- **THEN** the tool SHALL print a message directing the user to run `skey create` first and exit 0

### Requirement: SSH config sync after picker selection
After the per-key config wizard completes (or is skipped for an existing config), `skey config` SHALL always sync `~/.ssh/config` regardless of how the key was selected.

#### Scenario: Sync after picker flow
- **WHEN** a key is configured via the picker
- **THEN** `~/.ssh/config` managed block SHALL be updated exactly as it would be for `skey config -n <ns> <key>`

### Requirement: Explicit args bypass picker
When `-n` flag or a positional key-name argument is provided, the picker SHALL NOT appear.

#### Scenario: Namespace flag given
- **WHEN** `skey config -n work` is run
- **THEN** the namespace prompt or per-key wizard SHALL proceed directly, no picker shown

#### Scenario: Key-name argument given
- **WHEN** `skey config -n work github` is run
- **THEN** the per-key wizard SHALL run directly, no picker shown
