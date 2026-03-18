## 1. Subcommand Registration

- [x] 1.1 Add `status` case to the subcommand router dispatching to `cmd_status`
- [x] 1.2 Add `status` entry to `cmd_help` usage output

## 2. cmd_status — State and Filesystem Read

- [x] 2.1 If `~/.ssh/.skey.yaml` is absent, print "No namespaces configured. Run 'skey config' to get started." and exit 0
- [x] 2.2 Parse registered namespaces from `~/.ssh/.skey.yaml` into an array
- [x] 2.3 Scan `~/.ssh/*/` for directories containing key subdirs (subdirs with `id_ed25519`) — build list of detected namespace dirs
- [x] 2.4 For each registered namespace, collect key names from `~/.ssh/<namespace>/*/id_ed25519` paths

## 3. cmd_status — Output

- [x] 3.1 Print a styled header via `gum style`
- [x] 3.2 For each registered namespace, print namespace name and list of keys (or "(no keys)" if empty)
- [x] 3.3 Detect unregistered namespaces (detected dirs not in registered list); print them under a separate "Unregistered" section if any
- [x] 3.4 Check `~/.ssh/config` for sentinel line; print "SSH config: synced" or "SSH config: out of sync — run 'skey config'"

## 4. README Update

- [x] 4.1 Add `skey status` usage example to README
