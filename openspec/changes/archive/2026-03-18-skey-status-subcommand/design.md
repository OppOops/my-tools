## Context

`skey` creates keys and manages namespace configs, but has no way to show what's been set up. The status view reads from two sources: the filesystem (`~/.ssh/<namespace>/`) for actual key directories, and `~/.ssh/.skey.yaml` for registered namespaces. It is read-only with no side effects.

## Goals / Non-Goals

**Goals:**
- Display all registered namespaces with their key count and key names
- Show unregistered namespace directories (exist in `~/.ssh/` but not in `.skey.yaml`)
- Indicate `~/.ssh/config` managed block presence
- Use `gum` styling for a clean TUI output

**Non-Goals:**
- Showing key fingerprints or expiry (requires `ssh-keygen -l`, adds latency)
- Modifying any state
- Filtering or searching

## Decisions

**Decision: Scan filesystem AND state file, merge results**
Rationale: Keys can exist without being registered (e.g., created before `skey config` was run, or manually). Showing only registered namespaces would miss real keys. The status view walks `~/.ssh/*/` directories and cross-references `.skey.yaml` to mark which are registered.

**Decision: Detect "namespace directory" heuristically — contains a subdirectory with key files**
Rationale: Not every directory under `~/.ssh/` is a namespace (e.g., `~/.ssh/work/` could contain keys directly). A namespace dir is identified as a directory whose children are themselves directories containing `id_ed25519` files. This matches the structure `skey create` always produces.

**Decision: Single `gum style` block per namespace, plain `echo` for key list**
Rationale: Keeps output readable without excessive boxing. One styled header per namespace, then indented key names below. `~/.ssh/config` sync status shown as a footer line.

## Risks / Trade-offs

- `~/.ssh/` with many directories → loop may be slow. Acceptable for personal use.
- Heuristic namespace detection may misclassify hand-crafted dirs. Low risk; status is read-only.
