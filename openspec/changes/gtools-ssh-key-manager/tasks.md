## 1. Repository Structure

- [x] 1.1 Create `gtools/ssh-key-manager/` directory
- [x] 1.2 Create `gtools/ssh-key-manager/ssh-key-manager.sh` with shebang `#!/usr/bin/env bash` and executable bit set

## 2. gum Dependency Guard

- [x] 2.1 Add `command -v gum` check at script startup; print install hint and exit 1 if missing

## 3. Argument Parsing

- [x] 3.1 Parse optional `-C <comment>` flag from script arguments
- [x] 3.2 Parse optional `-n <namespace>` flag from script arguments
- [x] 3.3 Capture remaining positional argument as key name (if provided)

## 4. Namespace Resolution

- [x] 4.1 Resolve active namespace: `-n` flag > `GTOOLS_SSH_NAMESPACE` env var > hardcoded default `"work"`
- [x] 4.2 If no `-n` flag, prompt with `gum input --value "$resolved_namespace"` to allow confirmation or override
- [x] 4.3 Validate namespace matches `^[a-zA-Z0-9_-]+$`; print error and exit 1 if invalid

## 5. Key Name Input

- [x] 5.1 If no key name argument, prompt with `gum input --placeholder "ssh key name"`
- [x] 5.2 Validate key name matches `^[a-zA-Z0-9_-]+$`; print error and exit 1 if invalid

## 6. Directory Bootstrap

- [x] 6.1 If `~/.ssh/` does not exist, create it with `mkdir -p ~/.ssh && chmod 700 ~/.ssh`
- [x] 6.2 If `~/.ssh/<namespace>/` does not exist, create it with `mkdir -p ~/.ssh/<namespace> && chmod 700 ~/.ssh/<namespace>`

## 7. No-Overwrite Guard

- [x] 7.1 Check if `~/.ssh/<namespace>/<key-name>/` already exists
- [x] 7.2 If it exists, print error message showing the full path and exit 1

## 8. Key Generation

- [x] 8.1 Create `~/.ssh/<namespace>/<key-name>/` directory
- [x] 8.2 Run `ssh-keygen -t ed25519 -N "" -f ~/.ssh/<namespace>/<key-name>/id_ed25519` (append `-C <comment>` if provided)
- [x] 8.3 Handle non-zero exit from `ssh-keygen` with an error message and exit 1

## 9. Success Output

- [x] 9.1 Display success message via `gum style` showing the full path to the generated public key
