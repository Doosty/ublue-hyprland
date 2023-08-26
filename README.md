#### installation guide
- get a [fresh ublue iso](https://github.com/ublue-os/main/releases), make a bootable usb with something like [Fedora Media Writer](https://fedoraproject.org/workstation/download/), install with option ublue-base-main (no DE)
- after reboot you will boot into a black screen. this is normal, press ctrl+alt+f2 and login
- run `sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/doosty/ublue-hyprland:latest`
- after 'reboot' login and run:
```
just setup-flatpaks
just setup-keyd-hotkey-daemon
just setup-steam-gaming
just setup-dustee-specific-configs
```
- after another reboot login and run `Hyprland`, do this everytime you power on, there is no login greeter

#### things you should do right now, or know about
- win+alt+d open nwg-displays (Display settings) and setup your monitors & workspaces
- win+alt+d open nwg-look (GTK settings), select one of the Material-Black widget theme, Phinger Cursor with size that suits you, etc...
- win+enter to open terminal, `vi ~/.config/hypr/hyprland.conf` and edit hyprland config, atleast look through the keybinds 
- win+alt+d open firefox, then go `about:config`, search for vaapi and enable it
- win+x toggles waybar, i almost never show it
- optionally `just setup-gaming`, `just nix-install` if you use nix
- some default applications & desktop entries are missing. use [mimeo](https://xyne.dev/projects/mimeo) and [handlr](https://github.com/chmln/handlr) to fix them
```
# get desktop files
mimeo --finddesk | grep firefox
# get existing associations
handlr list --all
# read the mimeo and handlr docs to set them
# user override associations are in $HOME/.config/mimeapps.list
```
- probably a million other things you will need to figure out yourself, this image is barely configured