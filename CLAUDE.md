# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal toolkit of TUI tools built with **bash + [gum](https://github.com/charmbracelet/gum)**. Each tool lives under `gtools/<tool-name>/` with its own script, install helper, and README.

## Running a tool

```bash
# Directly
./gtools/ssh-key-manager/ssh-key-manager.sh

# After install
ssh-key-manager
```

## Installing a tool locally

```bash
cd gtools/<tool-name>
./install.sh                 # → ~/.local/bin/<tool-name>
./install.sh /usr/local/bin  # system-wide
```

## gtools conventions

- Entry point: `gtools/<tool-name>/<tool-name>.sh` — must have `#!/usr/bin/env bash`, `set -euo pipefail`, executable bit set
- Guard `gum` at startup with `command -v gum`; print install hint and `exit 1` if missing
- Validate all user inputs with `^[a-zA-Z0-9_-]+$` before acting on them
- Never overwrite existing state silently — fail fast with a clear error
- Install script: `gtools/<tool-name>/install.sh`, copies script to target dir, warns if dir not in `$PATH`

## OpenSpec workflow

Changes are planned and tracked under `openspec/changes/<change-name>/` using the `spec-driven` schema. Use the `/opsx:*` slash commands:

| Command | Purpose |
|---|---|
| `/opsx:propose` | Create a new change with proposal, design, specs, and tasks |
| `/opsx:explore` | Think through ideas before or during a change |
| `/opsx:apply` | Implement tasks from a change |
| `/opsx:archive` | Archive a completed change |

Artifact order: `proposal.md` → `design.md` + `specs/**/*.md` → `tasks.md`.

The `openspec/config.yaml` is where project context and per-artifact rules are set — update it when the tech stack or conventions evolve.
