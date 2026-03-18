## Context

`cmd_git_remote` in `skey.sh` currently resolves which alias to use by scanning all `.config.yaml` files under registered namespaces and matching the remote hostname. This is automatic but indirect — users cannot specify upfront which key to use. The change adds explicit `<workspace> <key-name>` positional args so users can direct the command exactly, with a `gum choose` picker as the interactive fallback.

## Goals / Non-Goals

**Goals:**
- Accept `skey git-remote [<workspace> [<key-name>]]` positional args
- When args are fully provided, derive alias as `<workspace>-<key-name>` and skip hostname lookup
- When args are absent, offer a `gum choose` picker over all `<namespace>/<key-name>` items from the workspace
- When only `<workspace>` is provided, narrow the picker to keys in that namespace
- Existing hostname-lookup flow is preserved as the default when picker-style resolution fails or no keys are registered

**Non-Goals:**
- Changing how the URL is rewritten after the alias is resolved (that logic stays unchanged)
- Adding workspace/key creation within this command
- Modifying other subcommands

## Decisions

**Positional args vs flags**
Chose positional args (`<workspace> <key-name>`) rather than `-w`/`-k` flags because the pattern matches `skey config [-n <ns>] <key>` and is more shell-script-friendly for direct invocation.

**Alias derivation**
When `<workspace>` and `<key-name>` are both given, compute `alias="${workspace}-${key-name}"` directly — no filesystem lookup required. This keeps the path fast and independent of whether a `.config.yaml` exists.

**Picker scope**
When only `<workspace>` is given, filter candidates to that namespace. Avoids surfacing unrelated keys and makes one-argument invocation useful.

**Fallback behavior**
If positional args are not given, the command uses the picker. If the picker produces an empty selection (user cancels), the command exits 0 with an informational message rather than falling back to hostname lookup — avoiding surprising implicit behavior.

## Risks / Trade-offs

- **Wrong alias if key has no `.config.yaml`** → The alias is derived from args directly; if the user supplies a workspace/key-name that doesn't exist in `~/.ssh/`, the git remote will be set to a non-working alias. Mitigation: validate that `~/.ssh/<workspace>/<key-name>/` exists before proceeding.
- **Hostname lookup no longer runs when args given** → Users who previously relied on auto-lookup now need to either omit args or use the picker. This is the intended trade-off for explicit control.

## Open Questions

- Should `skey git-remote <workspace>` (workspace only, no key) always show a picker, or should it error asking for the key-name? → Decision: show picker scoped to that workspace (consistent with config picker pattern).
