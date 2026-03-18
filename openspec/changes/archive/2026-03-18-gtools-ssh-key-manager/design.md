## Context

Developer SSH key workflows are repetitive and error-prone when done manually. This introduces `gtools/` — a personal TUI toolkit built on bash + [gum](https://github.com/charmbracelet/gum) — with `ssh-key-manager` as the first tool. The tool wraps `ssh-keygen` with interactive prompts and safety guards.

## Goals / Non-Goals

**Goals:**
- Provide an interactive TUI for creating SSH keys via `gum` prompts
- Create one dedicated folder per key at `~/.ssh/<namespace>/<key-name>/`
- Default namespace is `work`, controlled by `GTOOLS_SSH_NAMESPACE` env var
- Accept `-n <namespace>` flag to override the namespace per invocation
- Default to `ed25519` key type, empty passphrase, optional `-C` comment
- Refuse to create if the target key folder already exists (no overwrite)
- Establish `gtools/<tool-name>/` directory convention for future tools

**Non-Goals:**
- Key deletion, rotation, or listing existing keys
- SSH config (`~/.ssh/config`) modification
- Adding keys to `ssh-agent` automatically
- Support for key types other than `ed25519` (expandable later)

## Decisions

**Decision: One folder per SSH key (`~/.ssh/<namespace>/<key-name>/`)**
Rationale: Keeps keys organized and isolated by both namespace and name. Prevents naming conflicts at scale. Alternative (flat `~/.ssh/`) rejected because it doesn't scale past a handful of keys.

**Decision: Default namespace is `work`, not empty**
Rationale: Always landing in an organized namespace prevents accidental clutter at the root of `~/.ssh/`. An empty default would silently create flat keys, which defeats the purpose of the namespace feature. Users who want flat keys can set `GTOOLS_SSH_NAMESPACE=""` explicitly.

**Decision: Namespace resolution priority — flag > env var > default**
Rationale: The `-n` flag gives per-call control; `GTOOLS_SSH_NAMESPACE` sets a session/shell default; `"work"` is the hardcoded fallback. This mirrors conventional CLI tool patterns (e.g., AWS CLI profiles). Name chosen as `GTOOLS_SSH_NAMESPACE` (not `GTOOLS_NAMESPACE`) to keep it scoped to this tool until a cross-tool convention is established.

**Decision: Namespace directory created automatically, not guarded**
Rationale: The namespace dir (`~/.ssh/work/`) is just organizational infrastructure. The no-overwrite guard applies only to the key directory (`~/.ssh/work/<key-name>/`). Creating the namespace dir automatically removes friction without any safety risk.

**Decision: Interactive namespace prompt pre-fills from env var**
Rationale: Consistent with Option C pattern used for `-C`. When running interactively without `-n`, `gum input --value "$GTOOLS_SSH_NAMESPACE"` pre-fills the current default so users can confirm or change it.

**Decision: bash + gum (not a compiled tool)**
Rationale: Zero build step, easy to audit, portable to any machine with gum installed. Alternative (Go/Python TUI) rejected as over-engineering for personal scripting.

**Decision: Fail-fast on existing folder**
Rationale: Silent overwrites of SSH keys are a security hazard. The tool checks `[ -d ~/.ssh/<name> ]` and exits with a clear error if the folder exists. No `--force` flag — intentional friction.

**Decision: No passphrase by default (`-N ""`)**
Rationale: Personal tooling for developer workstations where keys are protected by OS keychain or hardware. Passphrase support can be added as a future interactive prompt.

**Decision: `-C` as optional CLI argument, not always prompted**
Rationale: Keeps the happy path fast. Users who want a comment pass it explicitly; the tool doesn't interrupt the flow for optional metadata.

## Risks / Trade-offs

- `gum` not installed → Tool exits with helpful install instructions. [Risk: bad UX on fresh machines] → Mitigation: guard at top of script with `command -v gum`.
- Key name with spaces or special chars → `ssh-keygen` may fail. [Risk: runtime error] → Mitigation: validate key name with a regex before proceeding.
- `~/.ssh/` doesn't exist → `mkdir` will create it with correct permissions. [Risk: incorrect permissions] → Mitigation: explicitly `chmod 700 ~/.ssh`.
