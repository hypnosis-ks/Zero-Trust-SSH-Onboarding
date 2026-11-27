#!/usr/bin/env bash
#Connecting to the SecurePay staging server using private SSH Key


set -euo pipefail

PRIVATE_KEY="$HOME/.ssh/school"

# Check whether the private key exists.

if [[ ! -f "$PRIVATE_KEY" ]]; then
    echo "Error: Private key not found at $PRIVATE_KEY" >&2
    exit 1

fi


# Connect to the staging server.

ssh -i "$PRIVATE_KEY" danielm@144.217.6.26
