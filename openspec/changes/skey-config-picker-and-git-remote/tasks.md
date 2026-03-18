## 1. Config Picker

- [x] 1.1 In `cmd_config`, detect the no-args-no-flags path (no `-n` flag and no key-name argument)
- [x] 1.2 Build picker list: walk registered namespaces from `.skey.yaml`, collect `<namespace>/<key-name>` for each key dir containing `id_ed25519`
- [x] 1.3 If picker list is empty, print "No keys found. Run 'skey create' first." and exit 0
- [x] 1.4 Present picker via `gum choose --header "Select key to configure:"` and capture selection
- [x] 1.5 Split selected item on `/` to extract namespace and key-name; route into existing per-key wizard path

## 2. skey git-remote Subcommand

- [x] 2.1 Implement `cmd_git_remote` with `-r <remote>` flag parsing (default `origin`)
- [x] 2.2 Check `git rev-parse --is-inside-work-tree`; if not a git repo, print info and exit 0
- [x] 2.3 Get remote URL via `git remote get-url <remote>`; if fails, print info and exit 0
- [x] 2.4 If URL starts with `http://` or `https://`, print "Remote URL is not SSH. Skipping." and exit 0
- [x] 2.5 Extract hostname from SCP-style (`git@host:path`) and `ssh://` URLs using regex
- [x] 2.6 Walk registered namespaces, collect `.config.yaml` files whose `hostname` matches extracted hostname
- [x] 2.7 If no matches, print info and exit 0
- [x] 2.8 If multiple matches, present aliases via `gum choose`; if single match, use directly
- [x] 2.9 Rewrite URL: replace hostname with alias in original URL format (preserve SCP vs ssh:// style)
- [x] 2.10 Run `git remote set-url <remote> <new-url>`
- [x] 2.11 Display old and new URL via `gum style`

## 3. Router and Help

- [x] 3.1 Add `git-remote` case to subcommand router dispatching to `cmd_git_remote`
- [x] 3.2 Add `git-remote [-r <remote>]` entry to `cmd_help` usage output

## 4. README

- [x] 4.1 Document `skey config` picker behaviour (no args = workspace picker)
- [x] 4.2 Add `skey git-remote` usage examples
