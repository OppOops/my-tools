## MODIFIED Requirements

### Requirement: Interactive key name prompt
The tool SHALL prompt the user for an SSH key name using a `gum input` field when no name is provided as an argument to the `create` subcommand.

#### Scenario: No argument given
- **WHEN** `skey create` is run with no positional argument
- **THEN** a `gum input` prompt SHALL appear asking for the key name

#### Scenario: Argument given
- **WHEN** `skey create <key-name>` is run with a key name as the positional argument
- **THEN** the prompt SHALL be skipped and the provided name used directly

### Requirement: Key name validation
The key name SHALL only contain alphanumeric characters, hyphens, and underscores. The tool SHALL reject invalid names and exit with code 1.

#### Scenario: Valid key name
- **WHEN** the user provides a name matching `^[a-zA-Z0-9_-]+$`
- **THEN** the script SHALL proceed to the namespace resolution step

#### Scenario: Invalid key name
- **WHEN** the user provides a name containing spaces or special characters
- **THEN** the script SHALL print a validation error and exit with code 1

### Requirement: Namespace resolution
The tool SHALL resolve the active namespace using the following priority: `-n` flag > `GTOOLS_SSH_NAMESPACE` env var > hardcoded default `"work"`.

#### Scenario: -n flag provided
- **WHEN** the user passes `-n <namespace>` to `skey create`
- **THEN** the namespace SHALL be set to the flag value, ignoring the env var

#### Scenario: env var set, no flag
- **WHEN** `GTOOLS_SSH_NAMESPACE` is set and no `-n` flag is given
- **THEN** the namespace SHALL be taken from the env var

#### Scenario: neither flag nor env var
- **WHEN** no `-n` flag is given and `GTOOLS_SSH_NAMESPACE` is unset or empty
- **THEN** the namespace SHALL default to `"work"`

### Requirement: Interactive namespace prompt
When running `skey create` interactively (no `-n` flag), the tool SHALL prompt for the namespace using `gum input` pre-filled with the resolved default.

#### Scenario: User accepts default namespace
- **WHEN** the namespace prompt appears and the user presses Enter without typing
- **THEN** the resolved default namespace SHALL be used

#### Scenario: User overrides namespace interactively
- **WHEN** the namespace prompt appears and the user types a different value
- **THEN** the typed value SHALL be used as the namespace

#### Scenario: -n flag skips prompt
- **WHEN** `-n <namespace>` is provided to `skey create`
- **THEN** the namespace prompt SHALL be skipped entirely

### Requirement: Namespace name validation
The namespace SHALL only contain alphanumeric characters, hyphens, and underscores. The tool SHALL reject invalid namespaces and exit with code 1.

#### Scenario: Valid namespace
- **WHEN** the namespace matches `^[a-zA-Z0-9_-]+$`
- **THEN** the script SHALL proceed to the directory bootstrap step

#### Scenario: Invalid namespace
- **WHEN** the namespace contains slashes or special characters
- **THEN** the script SHALL print a validation error and exit with code 1

### Requirement: Namespace directory bootstrap
The tool SHALL create `~/.ssh/<namespace>/` with permissions `700` if it does not already exist.

#### Scenario: Namespace directory does not exist
- **WHEN** `~/.ssh/<namespace>/` is absent
- **THEN** the tool SHALL create it with `mkdir -p` and `chmod 700` and continue

#### Scenario: Namespace directory already exists
- **WHEN** `~/.ssh/<namespace>/` already exists
- **THEN** the tool SHALL proceed without modifying it

### Requirement: No-overwrite folder guard
The tool SHALL check if `~/.ssh/<namespace>/<key-name>/` already exists before creating anything. If it exists, the tool SHALL abort with a clear error and exit code 1.

#### Scenario: Target key folder already exists
- **WHEN** `~/.ssh/<namespace>/<key-name>/` exists
- **THEN** the tool SHALL display an error message and exit with code 1 without modifying any files

#### Scenario: Target key folder does not exist
- **WHEN** `~/.ssh/<namespace>/<key-name>/` does not exist
- **THEN** the tool SHALL create the directory and proceed with key generation

### Requirement: SSH key generation
The tool SHALL generate an `ed25519` SSH key pair inside `~/.ssh/<namespace>/<key-name>/` with no passphrase. The key files SHALL be named `id_ed25519` and `id_ed25519.pub`.

#### Scenario: Successful key creation
- **WHEN** the folder is clear and key name is valid
- **THEN** `ssh-keygen -t ed25519 -N "" -f ~/.ssh/<namespace>/<key-name>/id_ed25519` SHALL be executed and both key files created

#### Scenario: Optional comment provided via -C flag
- **WHEN** the user passes `-C "my comment"` to `skey create`
- **THEN** the `-C` value SHALL be forwarded to `ssh-keygen` as the key comment

#### Scenario: No comment provided
- **WHEN** no `-C` flag is given
- **THEN** `ssh-keygen` SHALL be called without a `-C` argument

### Requirement: Success confirmation
After key generation, the tool SHALL display a styled success message via `gum style` showing the full key path and the public key content.

#### Scenario: Keys created successfully
- **WHEN** `ssh-keygen` exits with code 0
- **THEN** the tool SHALL print the key paths via `gum style` and output the public key content

### Requirement: ~/.ssh directory bootstrap
If `~/.ssh/` does not exist, the tool SHALL create it with permissions `700` before creating the namespace subfolder.

#### Scenario: ~/.ssh does not exist
- **WHEN** `~/.ssh/` is absent on the system
- **THEN** the tool SHALL create it with `mkdir -p ~/.ssh && chmod 700 ~/.ssh` before proceeding

#### Scenario: ~/.ssh already exists
- **WHEN** `~/.ssh/` is present
- **THEN** the tool SHALL not attempt to recreate or modify it
