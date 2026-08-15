# Simple Restic Role

This aims to be a simple ansible role for the restic backup solution. Uses the distros restic package and systemd units/timers.

Heavily inspired by [roles-ansible/ansible_role_restic](https://github.com/roles-ansible/ansible_role_restic).

## Setup

You need to setup the connection to your restic repository manually.
If you're using a sftp repository, make sure it is accessible without a password.

The restic repository has to be manually initialized as well, via `restic init`.

## License

This ansible role is under the MIT License. See the [LICENSE](LICENSE) file for the full license text.
