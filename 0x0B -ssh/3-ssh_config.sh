#!/usr/bin/env bash
#Configure the local SSH client to use the school key and disable password authentication

set -euo pipefail

SSH_DIR="$HOME/.ssh"
CONFIG_FILE="$SSH_DIR/config"
SERVER="144.217.6.26"

#Create the SSH directory if it does not exist
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

#Create the SSH configuration file if it does not exist
touch "$CONFIG_FILE"

#Avoid adding the same server configuration more than once.
if grep -qE "^Host[[:space:]]+$SERVER$" "$CONFIG_FILE"; then
	echo "SSH configuration for $SERVER already exists"
else
	cat >> "$CONFIG_FILE" <<EOF

Host $SERVER
    IdentifyFile ~/.ssh/school
    IdentitiesOnly yes
    PasswordAuthentication no
EOF


    echo "SSH configuration created successfully."

fi

# Restrict access to the configuration file.
chmod 600 "$CONFIG_FILE"
