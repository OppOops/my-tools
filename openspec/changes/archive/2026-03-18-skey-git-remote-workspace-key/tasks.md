## 1. Argument Parsing

- [x] 1.1 Update `cmd_git_remote` to accept two optional positional args: `<workspace>` and `<key-name>` after parsing flags
- [x] 1.2 Update `cmd_help` usage line for `git-remote` to reflect `[-r <remote>] [<workspace> [<key-name>]]`

## 2. Explicit Args Path

- [x] 2.1 When both `<workspace>` and `<key-name>` are provided, validate that `~/.ssh/<workspace>/<key-name>/` exists; print error and exit 1 if not
- [x] 2.2 When validation passes, set `chosen_alias="${workspace}-${key-name}"` and skip to URL rewrite, bypassing hostname lookup

## 3. Picker Path

- [x] 3.1 Extract helper logic to build the full list of `<workspace>/<key-name>` items from registered namespaces (reusable for both no-arg and workspace-only cases)
- [x] 3.2 When only `<workspace>` is provided, scope the picker to keys under that namespace; print skip message and exit 0 if none found
- [x] 3.3 When no positional args are provided and keys exist in workspace, show full picker; on empty selection print "No key selected. Skipping." and exit 0
- [x] 3.4 When no positional args are provided and no keys are in workspace, fall through to existing hostname-lookup flow
- [x] 3.5 Parse selected `<workspace>/<key-name>` string to derive `chosen_alias` as `<workspace>-<key-name>`

## 4. Validation & Tests

- [x] 4.1 Manual smoke test: `skey git-remote work github` rewrites remote without picker
- [x] 4.2 Manual smoke test: `skey git-remote work` shows picker scoped to `work` namespace
- [x] 4.3 Manual smoke test: `skey git-remote` with no args shows full picker
- [x] 4.4 Manual smoke test: cancelling picker exits 0 with skip message
- [x] 4.5 Manual smoke test: supplying unknown workspace/key prints error and exits 1
