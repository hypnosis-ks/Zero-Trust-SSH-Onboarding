#!/usr/bin/env bash
# SSH public Key for IT administrator


set -euo pipefail

KEY_FILE="$HOME/.ssh/school.pub"


if [[ ! -f "$KEY_FILE" ]]; then
    echo "Error: Public key not found at $KEY_FILE" >&2
    exit 1
fi



cat "$KEY_FILE"

printf '\nREMINDER: Send ONLY this public key. Never share your private key.\n'
