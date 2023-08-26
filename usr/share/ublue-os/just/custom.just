!include /usr/share/ublue-os/just/bling.just

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
  flatpak override org.mozilla.firefox --user --filesystem=$HOME/.mozilla
  echo 'Done. Reboot is recommended to apply the permissions to flatpaks.'

setup-steam-gaming:
  echo 'Setting up gaming experience...'
  flatpak install -y --user \\
  org.freedesktop.Platform.VulkanLayer.MangoHud//22.08 \\
  com.valvesoftware.Steam
  flatpak override --user --env=MANGOHUD=1 com.valvesoftware.Steam
  flatpak override --user --env=MANGOHUD=1 com.heroicgameslauncher.hgl
  echo 'Done.'

setup-keyd-hotkey-daemon:
  sudo rsync -r -a /usr/share/homedir-configs-optional/keyd/etc/ /etc/keyd
  rsync -r -a /usr/share/homedir-configs-optional/keyd/home/ $HOME/.config/keyd
  sudo usermod -aG keyd $USER
  sudo systemctl enable keyd.service --now
  echo 'Done. Reboot is recommended to apply the configuration to keyd. Configs are in $HOME/.config/keyd and /etc/keyd'

setup-dustee-specific-configs:
  rsync /usr/share/homedir-configs-optional/hypr/monitors.conf $HOME/.config/hypr/monitors.conf
  rsync /usr/share/homedir-configs-optional/hypr/workspaces.conf $HOME/.config/hypr/workspaces.conf
  echo 'Done.'
