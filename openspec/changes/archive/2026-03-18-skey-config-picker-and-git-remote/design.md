## Context

`skey config` today requires `-n <namespace> <key-name>` to target a key. Without args it only configures the namespace level. This change makes the no-arg path interactive: build a list of all keys from the workspace and let the user pick. The `skey git-remote` command leverages the per-key `alias` field to rewrite a git remote URL so SSH traffic routes through the managed `Host` entry.

## Goals / Non-Goals

**Goals:**
- `skey config` (no args, no flags) → `gum choose` picker of `<namespace>/<key-name>` items, then runs existing per-key wizard
- `skey config` still syncs `~/.ssh/config` after any selection
- `skey git-remote [-r <remote>]` → reads current git remote URL, replaces hostname with skey alias, sets new URL
- Skip gracefully (print info, exit 0) when: not in git repo, remote not set, or no matching skey key found for the repo's hostname

**Non-Goals:**
- Multi-remote support (beyond the one targeted remote)
- Reverse operation (un-rewriting a remote URL)
- Supporting non-SSH remote URLs (http/https remotes are skipped)

## Decisions

**Decision: Picker list built from filesystem, not just `.skey.yaml`**
Rationale: `.skey.yaml` tracks namespaces, not individual keys. The actual keys live at `~/.ssh/<namespace>/*/id_ed25519`. Walk registered namespaces from state file, collect key dirs, format as `<namespace>/<key-name>`. This is consistent with how `cmd_status` already works.

**Decision: Picker item format `<namespace>/<key-name>`, split on `/` to extract args**
Rationale: Single `gum choose` item unambiguously encodes both dimensions. After selection, split on `/` to recover `namespace` and `key_name`, then call into the existing per-key wizard path.

**Decision: `skey git-remote` hostname substitution via alias**
Rationale: Git SSH URLs have the form `git@<hostname>:<path>` or `ssh://<hostname>/<path>`. The skey alias is the `Host` entry in `~/.ssh/config`, so replacing the hostname portion with the alias causes SSH to route through the right key. Implementation: find the per-key `.config.yaml` whose `hostname` matches the remote's hostname, read its `alias`, substitute.

**Decision: `-r <remote>` flag for git-remote, default `origin`**
Rationale: `origin` covers 99% of personal use. The flag allows targeting `upstream` etc. without breaking the common case.

**Decision: Skip conditions are silent exit 0 with an info message**
Rationale: `skey git-remote` may be called from a shell function run in any directory. Erroring out on "not a git repo" would be noisy and break scripts. Info + exit 0 is the right contract.

## Risks / Trade-offs

- Hostname extraction from git remote URL requires handling both `git@host:path` and `ssh://host/path` formats. Mitigation: regex match both patterns.
- Multiple skey keys with the same hostname → ambiguous which alias to use. Mitigation: if multiple matches found, present `gum choose` to pick one.
