## ADDED Requirements

### Requirement: Global state file location
The global state file SHALL be at `~/.ssh/.skey.yaml`. It SHALL be created automatically on first use with permissions `600`.

#### Scenario: State file does not exist on first run
- **WHEN** any `skey` subcommand needs to read or write state and `~/.ssh/.skey.yaml` is absent
- **THEN** the file SHALL be created with an empty `namespaces` map

#### Scenario: State file permissions
- **WHEN** the state file is created
- **THEN** it SHALL have permissions `600`

### Requirement: State file schema
The state file SHALL follow this YAML schema:
```yaml
namespaces:
  <name>:
    config: <absolute-path-to-.skey-config.yaml>
```

#### Scenario: Reading a registered namespace
- **WHEN** the tool reads `~/.ssh/.skey.yaml`
- **THEN** it SHALL be able to retrieve the config path for any registered namespace by name

#### Scenario: Writing a new namespace
- **WHEN** a new namespace is registered
- **THEN** a new entry SHALL be appended under `namespaces` in the correct schema format
