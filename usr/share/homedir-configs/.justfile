default:
    @just --list
    
bios:
  systemctl reboot --firmware-setup

changelogs:
  rpm-ostree db diff --changelogs

distrobox-boxkit:
  echo 'Creating Boxkit distrobox ...'
  distrobox create --image ghcr.io/ublue-os/boxkit -n boxkit -Y

distrobox-debian:
  echo 'Creating Debian distrobox ...'
  distrobox create --image quay.io/toolbx-images/debian-toolbox:unstable -n debian -Y

distrobox-opensuse:
  echo 'Creating openSUSE distrobox ...'
  distrobox create --image quay.io/toolbx-images/opensuse-toolbox:tumbleweed -n opensuse -Y

distrobox-ubuntu:
  echo 'Creating Ubuntu distrobox ...'
  distrobox create --image quay.io/toolbx-images/ubuntu-toolbox:22.04 -n ubuntu -Y

update:
  rpm-ostree update
  flatpak update -y
  distrobox upgrade -a

setup-flatpaks:
  #!/usr/bin/env bash
  echo 'Adding Flathub repository ...'
  flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  echo 'Installing flatpaks from the ublue recipe ...'
  flatpaks=$(yq -- '.firstboot.flatpaks[]' "/usr/share/ublue-os/recipe.yml")
  for pkg in $flatpaks; do \
      echo "Installing: ${pkg}" && \
      flatpak install --user --noninteractive flathub $pkg; \
  done
  echo 'Enabling flatpak themes...'
  flatpak override --user --filesystem=$HOME/.themes
  flatpak override --user --filesystem=$HOME/.icons
  flatpak override --user --filesystem=$HOME/.fonts

setup-gaming:
  echo 'Setting up gaming experience ... lock and load.'
  flatpak install -y --user \\
  org.freedesktop.Platform.VulkanLayer.MangoHud//22.08 \\
  com.heroicgameslauncher.hgl \\
  com.usebottles.bottles \\
  com.valvesoftware.Steam \\
  com.valvesoftware.Steam.Utility.gamescope \\
  net.davidotek.pupgui2
  flatpak override com.usebottles.bottles --user --filesystem=xdg-data/applications 
  flatpak override --user --env=MANGOHUD=1 com.valvesoftware.Steam 
  flatpak override --user --env=MANGOHUD=1 com.heroicgameslauncher.hgl 

nix-install:
  echo 'Installing nix...'
  /usr/bin/ublue-nix-install

nix-uninstall:
  echo 'Uninstalling nix...'
  /usr/bin/ublue-nix-uninstall

run-post-install-commands:
  sudo systemctl set-default graphical.target
  sudo usermod -aG keyd $USER
  sudo systemctl enable keyd.service --now

install-dustee-specific-configs:
  sudo mkdir /etc/keyd
  sudo cp /usr/share/ublue-os/dustee-specific-configs-ignoreit/keyd/etc/* /etc/keyd/
  mkdir ~/.config/keyd
  cp /usr/share/ublue-os/dustee-specific-configs-ignoreit/keyd/home/* ~/.config/keyd/
  cp /usr/share/ublue-os/dustee-specific-configs-ignoreit/hypr/* ~/.config/hypr/

