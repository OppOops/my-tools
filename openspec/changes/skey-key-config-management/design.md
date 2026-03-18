## Context

The current `skey config` manages namespace-level state and writes a generic `Include` block to `~/.ssh/config`. This change pushes config down to the key level: each key gets a `.config.yaml` containing real SSH connection parameters, and the managed `~/.ssh/config` block is rebuilt by rendering a `Host` entry from each key's YAML.

A secondary fix addresses `^M` (CR, `\r`) characters appearing in generated content. This is caused by bash string concatenation with `$'\n'` in certain terminal environments and by `gum style` output being captured into variables. The fix is to pipe all generated content through `tr -d '\r'` before writing to files.

## Goals / Non-Goals

**Goals:**
- `skey config [-n <ns>] [key-name]` — when a key name is provided (or selected), run interactive per-key config wizard
- Store per-key config at `~/.ssh/<namespace>/<key-name>/.config.yaml`
- Auto-derive `alias` as `<namespace>-<key-name>` (prevents Host conflicts across namespaces)
- Default values for all fields except `hostname` (which is always prompted)
- Rebuild `~/.ssh/config` managed block from all per-key `.config.yaml` files found under registered namespaces
- Fix `^M` carriage returns in generated file content

**Non-Goals:**
- Editing an existing key config (create-only for now)
- Key deletion or deregistration
- Multiple hosts per key

## Decisions

**Decision: Per-key config at `~/.ssh/<namespace>/<key-name>/.config.yaml`**
Rationale: Co-located with the key itself. Dot-prefixed to avoid confusion with ssh key files. Schema:
```yaml
alias: work-github          # auto-derived: <namespace>-<key-name>
hostname: github.com        # required, always prompted
user: git                   # default: current $USER
port: 22                    # default: 22
identity_file: ~/.ssh/work/github/id_ed25519  # auto-derived
forward_agent: false        # default
server_alive_interval: 60   # default
```

**Decision: Alias auto-derived as `<namespace>-<key-name>`, not prompted**
Rationale: Guarantees uniqueness across namespaces without user burden. Users can still edit the YAML manually to override.

**Decision: Rebuild full `~/.ssh/config` block from all per-key YAMLs on every `skey config` run**
Rationale: Simpler and always correct. Walk `~/.ssh/<namespace>/*/` looking for `.config.yaml` files for namespaces registered in `.skey.yaml`. Render each as a `Host` block.

**Decision: Fix `^M` via `printf` instead of string concatenation + `echo`**
Rationale: The `^M` comes from bash's `echo` inserting `\r\n` in some environments and from `gum style` output captured via `$()`. Replace all file-writing with `printf '%s\n'` and strip `\r` from any captured gum output with `tr -d '\r'`.

**Decision: `skey config` with no key name = namespace-only config (existing behaviour)**
Rationale: Backward compatible. Key-level config is additive — it only triggers when a key name is given.

## Risks / Trade-offs

- Walking `~/.ssh/<namespace>/*/` for `.config.yaml` may pick up non-skey dirs. Mitigation: only walk namespaces registered in `.skey.yaml`.
- `^M` fix with `tr -d '\r'` is defensive but harmless on systems that don't produce CRs.
