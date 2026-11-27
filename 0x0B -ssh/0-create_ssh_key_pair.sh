#!/usr/bin/env bash
#Generate a 4096-bit RSA SSH key pair protected by a passphrase


set -euo pipefail

if [[ -e "school" || -e "school.pub" ]]; then
   echo "Error: school or school.pub already exists. Aborting."
   exit 1
fi

ssh-keygen -t rsa -b 4096 -f school -N "betty"


echo "SHH key pair generated successfully"
