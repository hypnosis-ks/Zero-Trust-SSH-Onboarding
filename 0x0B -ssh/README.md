# 0x0B - SSH

This folder contains the SSH onboarding scripts and Puppet manifest for the
SecurePay staging server.

# Environment

- Local Linux account: `travis`
- Remote account: `danielm`
- Staging server: `144.217.6.26`
- Private key: `~/.ssh/school`
- Public key: `~/.ssh/school.pub`

Change the remote username, host address, and Puppet local-user settings if
your administrator assigns different values.

# 1. Generate an SSH key pair

From this folder, run:

chmod +x *.sh
./0-create_ssh_key_pair.sh

This creates `school` (private key) and `school.pub` (public key) in the
current directory. The assignment passphrase is `betty`.

Copy the keys into your SSH directory:

mkdir -p ~/.ssh
cp school school.pub ~/.ssh/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/school
chmod 644 ~/.ssh/school.pub

Never share or upload `school`. Only `school.pub` should be given to the
administrator for registration.

# 2. Display the public key
Run:

./1-submit_public_key_pair.sh


The script displays `~/.ssh/school.pub`. Send that output to the administrator
through the approved channel. Do not send the private key.

# 3. Connect using the private key

After the administrator registers the public key, run:

./2-use_a_private_key.sh


The script connects as `danielm` to `144.217.6.26` using `~/.ssh/school`.
The private-key passphrase may still be requested; this is not the remote
account password.

# 4. Configure the SSH client

Run:

./3-ssh_config.sh

The script backs up an existing `~/.ssh/config` before replacing it with the
SecurePay host configuration. Review the backup if you had other SSH host
entries that you need to preserve.

The resulting configuration is:
Host 144.217.6.26
    IdentityFile ~/.ssh/school
    IdentitiesOnly yes
    PasswordAuthentication no

Verify the effective settings:

ssh -G danielm@144.217.6.26 | grep -E '^(hostname|identityfile|identitiesonly|passwordauthentication) '


Test the connection with verbose output:

ssh -v danielm@144.217.6.26


Look for the `school` identity being offered and successful `publickey`
authentication. `PasswordAuthentication no` disables remote password
authentication; it does not remove the passphrase protecting the local key.

# 5. Verify remote authorized_keys

After connecting to the server as `danielm`, check:

ls -ld ~/.ssh
ls -l ~/.ssh/authorized_keys
ssh-keygen -lf ~/.ssh/authorized_keys


Required permissions:


chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys


The fingerprint in `authorized_keys` should match the local public key:


ssh-keygen -lf ~/.ssh/school.pub

# 6. Enforce the SSH configuration with Puppet

The manifest manages `/home/travis/.ssh` and `/home/travis/.ssh/config`.
It sets the directory to `0700`, the config file to `0600`, and enforces the
required SSH directives.

Validate and apply:

puppet parser validate 100-puppet_ssh_config.pp
sudo puppet apply 100-puppet_ssh_config.pp


Verify:

cat ~/.ssh/config
ssh -G danielm@144.217.6.26 | grep -E '^(hostname|identityfile|identitiesonly|passwordauthentication) '

The manifest replaces the entire SSH config file with the declared content.
Back up any existing configuration before applying it if it contains other
host entries you need.

# Security notes

- Never share `~/.ssh/school`, the private key.
- Share only `~/.ssh/school.pub`.
- Use a strong, unique passphrase for real deployments. The passphrase `betty`
  is included only because it is specified by this exercise.
- A CI/CD runner needs access to an appropriate private key stored in the
  platform's secret store; registering a developer's public key does not
  automatically give Jenkins or GitHub Actions that private key.


# References

OpenSSH documentation

- OpenSSH SSH manual — SSH connections, authentication, host verification, and public-key authentication.
- OpenSSH ssh-keygen manual — Generating and managing SSH key pairs.
- OpenSSH sshd manual — Authorized keys, authentication, and server-side SSH behavior.
- OpenSSH ssh_config manual — SSH client configuration directives.


Puppet documentation

- Puppet File Resource — Managing files, directories, ownership, permissions, and file content.
- Puppet Resource Syntax — Writing Puppet resource declarations.
- Puppet Resources — Understanding desired-state configuration management.

Areas Where AI Assisted

SSH concepts - Explained public-key cryptography, private and public keys, host-key verification, authentication, and authorized keys.
Bash Scripting - Helped structure scripts, explain shell syntax, validate conditions, and improve error handling.
Puppet - Assisted with understanding Puppet resource declarations, file attributes, dependencies, permissions, and manifest validation.
