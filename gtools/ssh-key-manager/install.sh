#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${1:-$HOME/.local/bin}"
SCRIPT_NAME="ssh-key-manager"
SCRIPT_SRC="$(cd "$(dirname "$0")" && pwd)/ssh-key-manager.sh"

if [[ ! -f "$SCRIPT_SRC" ]]; then
  echo "Error: ssh-key-manager.sh not found at ${SCRIPT_SRC}" >&2
  exit 1
fi

mkdir -p "$INSTALL_DIR"
cp "$SCRIPT_SRC" "${INSTALL_DIR}/${SCRIPT_NAME}"
chmod +x "${INSTALL_DIR}/${SCRIPT_NAME}"

echo "Installed: ${INSTALL_DIR}/${SCRIPT_NAME}"

if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
  echo "Note: ${INSTALL_DIR} is not in your PATH."
  echo "Add this to your shell profile:"
  echo "  export PATH=\"${INSTALL_DIR}:\$PATH\""
fi
