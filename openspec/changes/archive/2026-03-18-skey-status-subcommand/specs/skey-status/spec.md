## ADDED Requirements

### Requirement: Status subcommand entry point
The script SHALL support `skey status` as a subcommand that displays the current SSH workspace overview and exits 0. It SHALL be registered in the subcommand router and listed in `cmd_help`.

#### Scenario: Status invoked
- **WHEN** the user runs `skey status`
- **THEN** the workspace overview SHALL be printed and the command exits 0

#### Scenario: Status listed in help
- **WHEN** the user runs `skey help`
- **THEN** `status` SHALL appear as a subcommand in the usage output

### Requirement: Namespace listing from state file
`skey status` SHALL read `~/.ssh/.skey.yaml` and display all registered namespaces. If the state file does not exist, it SHALL display a message indicating no namespaces are configured.

#### Scenario: Namespaces registered
- **WHEN** `~/.ssh/.skey.yaml` contains one or more namespaces
- **THEN** each namespace name SHALL be shown in the output

#### Scenario: State file absent
- **WHEN** `~/.ssh/.skey.yaml` does not exist
- **THEN** the output SHALL indicate no namespaces have been configured yet

### Requirement: Keys listed per namespace
For each registered namespace, `skey status` SHALL list the key directories found under `~/.ssh/<namespace>/`. A key directory is a subdirectory containing an `id_ed25519` file.

#### Scenario: Keys exist under namespace
- **WHEN** `~/.ssh/<namespace>/` contains subdirectories with `id_ed25519` files
- **THEN** each key name SHALL be listed under its namespace

#### Scenario: No keys under namespace
- **WHEN** `~/.ssh/<namespace>/` exists but contains no key directories
- **THEN** the namespace SHALL still be shown with a "(no keys)" indicator

### Requirement: Unregistered namespace detection
`skey status` SHALL scan `~/.ssh/` for directories that match the namespace heuristic (contain subdirs with `id_ed25519`) but are NOT registered in `.skey.yaml`. These SHALL be displayed separately as unregistered namespaces.

#### Scenario: Unregistered namespace found
- **WHEN** a directory under `~/.ssh/` contains key subdirs but is not in `.skey.yaml`
- **THEN** it SHALL appear under an "Unregistered namespaces" section

#### Scenario: No unregistered namespaces
- **WHEN** all detected namespace directories are registered
- **THEN** the unregistered section SHALL be omitted

### Requirement: SSH config sync status
`skey status` SHALL check whether `~/.ssh/config` contains the skey managed block and display a sync status indicator.

#### Scenario: Managed block present
- **WHEN** `~/.ssh/config` contains the sentinel lines
- **THEN** the output SHALL show a "synced" indicator for SSH config

#### Scenario: Managed block absent
- **WHEN** `~/.ssh/config` does not contain the sentinel lines
- **THEN** the output SHALL show an "out of sync — run skey config" indicator
