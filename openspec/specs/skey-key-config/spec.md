## Requirements

### Requirement: Per-key config wizard
When `skey config` is invoked with a key name argument, the tool SHALL run an interactive wizard collecting SSH connection fields for that key. The wizard SHALL prompt for `hostname` (required) and optionally for `user`, `port`, `forward_agent`, and `server_alive_interval`, with sensible defaults pre-filled.

#### Scenario: Key name provided to config
- **WHEN** the user runs `skey config [-n <namespace>] <key-name>`
- **THEN** the per-key config wizard SHALL launch for that key

#### Scenario: Hostname prompt
- **WHEN** the wizard runs
- **THEN** a `gum input` prompt SHALL ask for hostname with no default value

#### Scenario: Optional fields with defaults
- **WHEN** the wizard prompts for `user`, `port`, `forward_agent`, `server_alive_interval`
- **THEN** each field SHALL be pre-filled with its default value and the user may accept or override

### Requirement: Per-key config YAML storage
The tool SHALL write the collected fields to `~/.ssh/<namespace>/<key-name>/.config.yaml`. If the file already exists, the wizard SHALL be skipped and the existing config used.

#### Scenario: Config file does not exist
- **WHEN** `~/.ssh/<namespace>/<key-name>/.config.yaml` is absent
- **THEN** the tool SHALL create it with all collected fields including auto-derived `alias` and `identity_file`

#### Scenario: Config file already exists
- **WHEN** `~/.ssh/<namespace>/<key-name>/.config.yaml` already exists
- **THEN** the tool SHALL skip the wizard and proceed to SSH config regeneration

### Requirement: Auto-derived alias
The `alias` field in the per-key YAML SHALL be automatically set to `<namespace>-<key-name>` without prompting. This value is used as the `Host` name in `~/.ssh/config`.

#### Scenario: Alias derivation
- **WHEN** a per-key config is created for namespace `work` and key `github`
- **THEN** `alias` SHALL be `work-github` in the YAML

### Requirement: Auto-derived identity_file
The `identity_file` field SHALL be automatically set to the absolute path `~/.ssh/<namespace>/<key-name>/id_ed25519` without prompting.

#### Scenario: Identity file path
- **WHEN** a per-key config is written
- **THEN** `identity_file` SHALL be `~/.ssh/<namespace>/<key-name>/id_ed25519`

### Requirement: Per-key YAML schema
The per-key config file SHALL contain these fields:
- `alias`: string (auto-derived)
- `hostname`: string (required, user-provided)
- `user`: string (default: `$USER`)
- `port`: integer (default: `22`)
- `identity_file`: string (auto-derived)
- `forward_agent`: boolean (default: `false`)
- `server_alive_interval`: integer (default: `60`)

#### Scenario: Written YAML contains all fields
- **WHEN** the wizard completes
- **THEN** the YAML file SHALL contain all seven fields with their collected or default values
