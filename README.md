# ansible-playbook-traumwiese

Just pretix for now.

## Usage

Create a `group_vars/all/vault.yml` file and configure all necessary variables (all prefixed with `vault_`). Then run

```
make deploy
```

This installs Ansible with all requirements and runs the `site.yml` playbook.

You can run a single playbook (e.g. `gesundheit.playbook.yml`) via

```
make deploy PLAYBOOK=gesundheit.playbook.yml
```

## Administration

### Backup

To setup restic backups to a hetzner storage box, follow the following steps:

1. Create a new hetzner storage box / subaccount of an existing storage box.
2. Set `vault_restic_repository_location_host` and `vault_restic_repository_location_user` in your Ansible vault accordingly.
3. Create a new (passwordless) ssh keypair (preferably ed25519) with `ssh-keygen -t ed25519 -C "hostname@backup" -f ./backup_key` and add it the Ansible Vault as the `vault_restic_repository_location_ssh_private_key` variable.
4. Add this ssh key to your storage box
   `cat backup_key.pub | ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password -p 23 USER@USER.your-storagebox.de install-ssh-key`
   You might have to turn on "Externe Erreichbarkeit" for this step. See the [Hetzner docs](https://docs.hetzner.com/de/storage/storage-box/backup-space-ssh-keys) for details.
5. Generate an encrypted password for the restic repository via systemd. Run this command on the target host:
   `systemd-ask-password -n | systemd-creds encrypt --name=restic-password -p - -`
   Add everything after `SetCredentialEncrypted=` to the Ansible vault as the `vault_restic_repository_encrypted_password` variable.
6. Run the `backup.playbook.yml` Ansible playbook via `make deploy PLAYBOOK=backup.playbook.yml`
7. Initialize the restic repository via `restic init -r sftp:USER@USER.your-storagebox.de:REPOSITORY_NAME`
8. Check if the backup sucessfully runs with `systemctl start restic-REPOSITORY-NAME`
9. Optionally check the modified time of the generated stamp file in `/var/lib/restic` in your monitoring.
