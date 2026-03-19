## Requirements

### Requirement: git-remote subcommand entry point
The script SHALL support `skey git-remote [-r <remote>] [<workspace> [<key-name>]]` as a subcommand. The default remote name SHALL be `origin`. The `<workspace>` and `<key-name>` positional arguments are optional. It SHALL be registered in the subcommand router and listed in `cmd_help`.

#### Scenario: Invoked with default remote
- **WHEN** `skey git-remote` is run
- **THEN** the tool SHALL operate on the `origin` remote

#### Scenario: Invoked with custom remote flag
- **WHEN** `skey git-remote -r upstream` is run
- **THEN** the tool SHALL operate on the `upstream` remote

#### Scenario: Invoked with workspace and key-name
- **WHEN** `skey git-remote work github` is run
- **THEN** the tool SHALL resolve the alias as `work-github` and rewrite the remote URL without showing a picker or performing hostname lookup

#### Scenario: Invoked with workspace only
- **WHEN** `skey git-remote work` is run
- **THEN** the tool SHALL show a `gum choose` picker scoped to keys under the `work` namespace

#### Scenario: Invoked with no positional args
- **WHEN** `skey git-remote` is run with no workspace or key-name
- **THEN** the tool SHALL show a `gum choose` picker listing all `<workspace>/<key-name>` items from registered namespaces

### Requirement: Skip if not in a git repository
If the current directory is not inside a git repository, the tool SHALL print an informational message and exit 0.

#### Scenario: Not in git repo
- **WHEN** `skey git-remote` is run outside of a git repository
- **THEN** the tool SHALL print "Not a git repository. Skipping." and exit 0

### Requirement: Skip if remote URL is not set
If the specified remote does not exist or has no URL, the tool SHALL print an informational message and exit 0.

#### Scenario: Remote not configured
- **WHEN** the specified remote is not set in the current git repo
- **THEN** the tool SHALL print "Remote '<name>' not found. Skipping." and exit 0

### Requirement: Skip non-SSH remote URLs
If the remote URL uses http or https, the tool SHALL print an informational message and exit 0.

#### Scenario: HTTPS remote URL
- **WHEN** the remote URL starts with `https://` or `http://`
- **THEN** the tool SHALL print "Remote URL is not SSH. Skipping." and exit 0

### Requirement: Hostname extraction from SSH remote URL
The tool SHALL extract the hostname from both SSH URL formats:
- `git@<hostname>:<path>` (SCP-style)
- `ssh://<hostname>/<path>` (explicit SSH protocol)

#### Scenario: SCP-style URL
- **WHEN** remote URL is `git@github.com:user/repo.git`
- **THEN** extracted hostname SHALL be `github.com`

#### Scenario: ssh:// URL
- **WHEN** remote URL is `ssh://git@github.com/user/repo.git`
- **THEN** extracted hostname SHALL be `github.com`

### Requirement: Alias lookup by hostname
The tool SHALL search all per-key `.config.yaml` files under registered namespaces for a `hostname` matching the extracted hostname. The matching key's `alias` SHALL be used as the replacement.

#### Scenario: Single matching key found
- **WHEN** exactly one `.config.yaml` has `hostname: github.com`
- **THEN** its `alias` SHALL be used to rewrite the remote URL

#### Scenario: Multiple matching keys found
- **WHEN** multiple `.config.yaml` files share the same hostname
- **THEN** `gum choose` SHALL present the matching aliases and the user SHALL select one

#### Scenario: No matching key found
- **WHEN** no `.config.yaml` has a matching hostname
- **THEN** the tool SHALL print "No skey key found for hostname '<hostname>'. Skipping." and exit 0

### Requirement: Remote URL rewrite
The tool SHALL replace the hostname in the remote URL with the selected alias and set the new URL via `git remote set-url`.

#### Scenario: SCP-style rewrite
- **WHEN** alias is `work-github` and original URL is `git@github.com:user/repo.git`
- **THEN** new URL SHALL be `git@work-github:user/repo.git`

#### Scenario: ssh:// rewrite
- **WHEN** alias is `work-github` and original URL is `ssh://git@github.com/user/repo.git`
- **THEN** new URL SHALL be `ssh://git@work-github/user/repo.git`

#### Scenario: Success output
- **WHEN** the URL is successfully rewritten
- **THEN** the tool SHALL display the old and new URL via `gum style`

### Requirement: Explicit workspace and key-name resolve alias directly
When both `<workspace>` and `<key-name>` are provided, the tool SHALL derive the alias as `<workspace>-<key-name>` and use it to rewrite the remote URL, skipping hostname lookup entirely.

#### Scenario: Both args provided — valid key directory
- **WHEN** `skey git-remote work github` is run and `~/.ssh/work/github/` exists
- **THEN** the alias `work-github` SHALL be used to rewrite the remote URL

#### Scenario: Both args provided — key directory does not exist
- **WHEN** `skey git-remote work github` is run and `~/.ssh/work/github/` does not exist
- **THEN** the tool SHALL print an error "Key 'work/github' not found." and exit 1

### Requirement: Workspace-only argument narrows picker
When only `<workspace>` is provided, the tool SHALL present a `gum choose` picker listing all `<key-name>` entries found under `~/.ssh/<workspace>/` in registered namespaces.

#### Scenario: Workspace has keys
- **WHEN** `skey git-remote work` is run and `work` namespace has keys `github` and `gitlab`
- **THEN** `gum choose` SHALL present `work/github` and `work/gitlab`

#### Scenario: Workspace has no keys
- **WHEN** `skey git-remote work` is run and no keys exist under the `work` namespace
- **THEN** the tool SHALL print "No keys found in workspace 'work'. Skipping." and exit 0

### Requirement: No-arg picker shows all workspace keys
When no positional arguments are provided, the tool SHALL present a `gum choose` picker over all `<workspace>/<key-name>` items from all registered namespaces before attempting hostname lookup.

#### Scenario: Keys exist across namespaces
- **WHEN** `skey git-remote` is run with no args and keys exist in the workspace
- **THEN** `gum choose` SHALL list all `<workspace>/<key-name>` entries

#### Scenario: User cancels picker
- **WHEN** the user cancels or makes no selection in the picker
- **THEN** the tool SHALL print "No key selected. Skipping." and exit 0

#### Scenario: No keys in workspace
- **WHEN** `skey git-remote` is run with no args and no keys are registered
- **THEN** the tool SHALL fall through to hostname-lookup flow
