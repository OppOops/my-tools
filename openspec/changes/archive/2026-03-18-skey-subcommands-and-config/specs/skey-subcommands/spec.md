## ADDED Requirements

### Requirement: Subcommand dispatch
The script SHALL route execution based on the first positional argument as a subcommand: `create`, `config`, or `help`. An unknown subcommand SHALL print an error and exit 1.

#### Scenario: create subcommand
- **WHEN** the user runs `skey create [flags] [key-name]`
- **THEN** the key creation flow SHALL execute with all flags and arguments forwarded

#### Scenario: config subcommand
- **WHEN** the user runs `skey config [flags]`
- **THEN** the config generation flow SHALL execute

#### Scenario: help subcommand
- **WHEN** the user runs `skey help` or `skey` with no arguments
- **THEN** a usage summary SHALL be printed listing available subcommands and their flags

#### Scenario: unknown subcommand
- **WHEN** the user runs `skey foo`
- **THEN** the script SHALL print `Error: Unknown subcommand 'foo'` and exit 1

### Requirement: Installed binary name
The install script SHALL install the tool as `skey` (not `ssh-key-manager`).

#### Scenario: Install produces skey binary
- **WHEN** `install.sh` is run
- **THEN** the installed file SHALL be named `skey` at the target directory
