## Why

Personal CLI tooling is fragmented and hard to reuse. A unified TUI toolkit built with bash + gum provides interactive, visually consistent tools for common developer tasks — starting with SSH key management.

## What Changes

- Introduce `gtools/` as the root directory for all personal TUI tools
- Add `gtools/ssh-key-manager/` as the first tool — an interactive SSH key creation wizard
- SSH keys are created at `~/.ssh/<namespace>/<ssh-key-name>/` with a dedicated subfolder per key
- Default namespace is `work`; configurable via `GTOOLS_SSH_NAMESPACE` env var or `-n` flag
- Key type defaults to `ed25519`, no passphrase, with an optional `-C` comment flag
- The tool refuses to overwrite an existing key folder, ensuring safety

## Capabilities

### New Capabilities

- `gtools-framework`: Shared conventions and structure for bash + gum TUI tools under `gtools/`
- `ssh-key-manager`: Interactive TUI for creating SSH keys with safe directory management

### Modified Capabilities

_(none)_

## Impact

- New top-level directory: `gtools/`
- New tool: `gtools/ssh-key-manager/ssh-key-manager.sh`
- External dependencies: `gum` (must be installed), `ssh-keygen` (standard)
- No existing code modified
