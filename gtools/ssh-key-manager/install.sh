#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${1:-$HOME/.local/bin}"
SCRIPT_NAME="skey"
REMOTE_URL="https://raw.githubusercontent.com/OppOops/my-tools/refs/heads/main/gtools/ssh-key-manager/skey.sh"

mkdir -p "$INSTALL_DIR"

# When run locally (skey.sh exists next to install.sh), copy it directly.
# When piped via curl, download skey.sh from GitHub.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"
if [[ -f "${SCRIPT_DIR}/skey.sh" ]]; then
  cp "${SCRIPT_DIR}/skey.sh" "${INSTALL_DIR}/${SCRIPT_NAME}"
else
  curl -fsSL "$REMOTE_URL" -o "${INSTALL_DIR}/${SCRIPT_NAME}"
fi

chmod +x "${INSTALL_DIR}/${SCRIPT_NAME}"

echo "Installed: ${INSTALL_DIR}/${SCRIPT_NAME}"

if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
  echo "Note: ${INSTALL_DIR} is not in your PATH."
  echo "Add this to your shell profile:"
  echo "  export PATH=\"${INSTALL_DIR}:\$PATH\""
fi
