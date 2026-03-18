## ADDED Requirements

### Requirement: Tool directory structure
Each gtools tool SHALL reside in its own directory at `gtools/<tool-name>/` within the repository root. The main entry point SHALL be a script named `<tool-name>.sh`.

#### Scenario: Directory layout for a new tool
- **WHEN** a new tool named `foo` is added
- **THEN** its files SHALL be at `gtools/foo/foo.sh` (and any supporting files under `gtools/foo/`)

### Requirement: gum dependency guard
Every gtools script SHALL check for the presence of `gum` at startup and exit with a human-readable install message if it is not found.

#### Scenario: gum is missing
- **WHEN** a gtools script is run and `gum` is not in `$PATH`
- **THEN** the script SHALL print an install hint (e.g., `brew install gum`) and exit with code 1

#### Scenario: gum is present
- **WHEN** a gtools script is run and `gum` is available
- **THEN** the script SHALL continue to its main logic without any warning

### Requirement: Script is directly executable
Each tool's main script SHALL have its executable bit set and include a proper shebang (`#!/usr/bin/env bash`).

#### Scenario: Running the script directly
- **WHEN** the user runs `./gtools/ssh-key-manager/ssh-key-manager.sh`
- **THEN** the script SHALL execute without requiring an explicit `bash` prefix
