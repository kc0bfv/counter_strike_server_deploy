# Prerequisites

* Download terraform from HashiCorp - https://www.terraform.io/downloads.html
* Install Ansible

# Usage

## Terraform

First, use Terraform to setup a VM on AWS:

* Setup AWS credentials as in - https://registry.terraform.io/providers/hashicorp/aws/latest/docs - and change counterstrike.tf to show the correct AWS profile name
* Change into the terraform directory and edit the config
* Set an ipv4 cidr block that doesn't conflict with your other VPCs in the region
* Run `ssh-keygen` in the terraform directory, and create `./key` and `./key.pub`.
* From terraform directory run `terraform init`

## Ansible

Now, use Ansible to configure your host.

* Put a nice random password into the file `secrets_password` - just put it as the only content in that file
* Now create the configuration needed by running `ansible-vault create --vault-password-file secrets_password server_secrets.enc`
* In there, fill in the following items:

```
server_admin_id: STEAM_... - your steam id, so you can be the admin
server_connect_password: whatever password you want for people connecting
server_name: your server name
server_rcon_password: a remote console password
server_steam_account: the steam account of your server steam account (create one) https://developer.valvesoftware.com/wiki/Counter-Strike:_Global_Offensive_Dedicated_Servers
server_webapi_authkey: the webapi for your steam account https://developer.valvesoftware.com/wiki/CSGO_Workshop_For_Server_Operators
server_dns_update_endpoint: the wget endpoint for your dynamic dns host, if you don't have one get one at freedns.afraid.org
server_steam_user: a steam user setup specifically for your server, and with CS2 already added to the account
```

* Run `ansible-playbook playbook.yml`

Reboot the server when complete and things should all startup correctly.

EXCEPT - that currently CS2.0 requires a login to update and such...

* After rebooting, the update will fail because you aren't logged in, but lots of stuff gets setup anyway, so do the reboot.
* SSH in and go to the steam user
* Run `/usr/.../steamcmd +login STEAM_USER PASSWORD +quit`, and do the steam guard login.  That will cache your user.
* Now run `start20Server` to do the update
* You may have to make a symbolic link from `/home/steam/.local/share/Steam/steamcmd/linux64` to `/home/steam/.steam/sdk64`

## Metamod and Sourcemod

After reboot, login, change to steam, and download metamod and sourcemod to the box.  Then cd to `Steam/server/csgo`.  Untar the metamod archive there, then untar the sourcemod archive.

Some useful plugins are last man, rockthemode, damage report, nextmapmode.  Copy them onto the box.  Move the smx files into `~steam/Steam/server/csgo/addons/sourcemod/plugins`, move `rockthemode.phrases.txt` into `~steam/Steam/server/csgo/addons/sourcemod/translations`.  Cd into `../Steam/server/csgo/` and unzip last man's zip.  Also move nominations, mapchooser, and rockthevote out of the disabled `~/Steam/server/csgo/addons/sourcemod/plugins` folder.  Then restart the server.
