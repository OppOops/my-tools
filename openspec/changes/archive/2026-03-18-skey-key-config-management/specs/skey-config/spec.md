## MODIFIED Requirements

### Requirement: Managed block in ~/.ssh/config
`skey config` SHALL upsert a managed section in `~/.ssh/config` bounded by sentinel lines. The block SHALL contain one `Host` entry per per-key `.config.yaml` found under registered namespaces, rendered with the key's SSH fields.

#### Scenario: No managed block exists
- **WHEN** `~/.ssh/config` has no managed block
- **THEN** the block SHALL be appended at the end of the file

#### Scenario: Managed block already exists
- **WHEN** `~/.ssh/config` contains an existing managed block
- **THEN** the block SHALL be replaced in-place with rendered `Host` entries for all known per-key configs

#### Scenario: Content outside block is preserved
- **WHEN** `~/.ssh/config` has manual entries above or below the managed block
- **THEN** those entries SHALL remain untouched after the update

#### Scenario: Host entry rendered from per-key config
- **WHEN** `~/.ssh/work/github/.config.yaml` exists with alias `work-github` and hostname `github.com`
- **THEN** the managed block SHALL contain a `Host work-github` entry with `HostName`, `User`, `Port`, `IdentityFile`, `ForwardAgent`, and `ServerAliveInterval` fields

### Requirement: Carriage return characters absent from generated files
All content written to `~/.ssh/config` and per-key `.config.yaml` files SHALL be free of carriage return (`\r`) characters.

#### Scenario: No ^M in generated SSH config
- **WHEN** `~/.ssh/config` is updated by `skey config`
- **THEN** the file SHALL contain no `\r` characters

#### Scenario: No ^M in per-key YAML
- **WHEN** `~/.ssh/<namespace>/<key-name>/.config.yaml` is written
- **THEN** the file SHALL contain no `\r` characters
