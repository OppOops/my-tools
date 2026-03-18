#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# gtools/ssh-key-manager — interactive SSH key creation TUI
# ---------------------------------------------------------------------------

# 2.1 — gum dependency guard
if ! command -v gum &>/dev/null; then
  echo "Error: 'gum' is not installed." >&2
  echo "Install it with: brew install gum  OR  go install github.com/charmbracelet/gum@latest" >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# 3. Argument parsing
# ---------------------------------------------------------------------------
COMMENT=""
NAMESPACE_FLAG=""
KEY_NAME_ARG=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -C)
      COMMENT="${2:-}"
      shift 2
      ;;
    -n|--namespace)
      NAMESPACE_FLAG="${2:-}"
      shift 2
      ;;
    -*)
      echo "Error: Unknown flag: $1" >&2
      exit 1
      ;;
    *)
      KEY_NAME_ARG="$1"
      shift
      ;;
  esac
done

# ---------------------------------------------------------------------------
# 4. Namespace resolution
# ---------------------------------------------------------------------------

# 4.1 — resolve: -n flag > env var > default "work"
if [[ -n "$NAMESPACE_FLAG" ]]; then
  NAMESPACE="$NAMESPACE_FLAG"
  NAMESPACE_FROM_FLAG=true
else
  NAMESPACE="${GTOOLS_SSH_NAMESPACE:-work}"
  NAMESPACE_FROM_FLAG=false
fi

# 4.2 — if no -n flag, prompt with pre-filled default
if [[ "$NAMESPACE_FROM_FLAG" == false ]]; then
  NAMESPACE="$(gum input --prompt "Namespace: " --value "$NAMESPACE")"
fi

# 4.3 — validate namespace
if [[ ! "$NAMESPACE" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "Error: Invalid namespace '${NAMESPACE}'. Use only letters, numbers, hyphens, and underscores." >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# 5. Key name input
# ---------------------------------------------------------------------------

# 5.1 — prompt if not provided as argument
if [[ -z "$KEY_NAME_ARG" ]]; then
  KEY_NAME="$(gum input --prompt "Key name: " --placeholder "ssh key name")"
else
  KEY_NAME="$KEY_NAME_ARG"
fi

# 5.2 — validate key name
if [[ ! "$KEY_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "Error: Invalid key name '${KEY_NAME}'. Use only letters, numbers, hyphens, and underscores." >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# 6. Directory bootstrap
# ---------------------------------------------------------------------------
SSH_DIR="$HOME/.ssh"
NAMESPACE_DIR="${SSH_DIR}/${NAMESPACE}"
KEY_DIR="${NAMESPACE_DIR}/${KEY_NAME}"
KEY_FILE="${KEY_DIR}/id_ed25519"

# 6.1 — ensure ~/.ssh exists
if [[ ! -d "$SSH_DIR" ]]; then
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"
fi

# 6.2 — ensure ~/.ssh/<namespace>/ exists
if [[ ! -d "$NAMESPACE_DIR" ]]; then
  mkdir -p "$NAMESPACE_DIR"
  chmod 700 "$NAMESPACE_DIR"
fi

# ---------------------------------------------------------------------------
# 7. No-overwrite guard
# ---------------------------------------------------------------------------

# 7.1 + 7.2 — abort if key directory already exists
if [[ -d "$KEY_DIR" ]]; then
  echo "Error: Key directory already exists: ${KEY_DIR}" >&2
  echo "Choose a different key name or namespace." >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# 8. Key generation
# ---------------------------------------------------------------------------

# 8.1 — create key directory
mkdir -p "$KEY_DIR"

# 8.2 — build ssh-keygen command
KEYGEN_ARGS=(-t ed25519 -N "" -f "$KEY_FILE")
if [[ -n "$COMMENT" ]]; then
  KEYGEN_ARGS+=(-C "$COMMENT")
fi

# 8.3 — run ssh-keygen, handle errors
if ! ssh-keygen "${KEYGEN_ARGS[@]}"; then
  echo "Error: ssh-keygen failed. Cleaning up..." >&2
  rm -rf "$KEY_DIR"
  exit 1
fi

# ---------------------------------------------------------------------------
# 9. Success output
# ---------------------------------------------------------------------------
gum style \
  --border rounded \
  --padding "1 2" \
  --foreground 2 \
  "SSH key created successfully!" \
  "" \
  "Private key : ${KEY_FILE}" \
  "Public key  : ${KEY_FILE}.pub"
