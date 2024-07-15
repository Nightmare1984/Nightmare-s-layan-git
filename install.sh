#!/bin/bash
#set -e
echo "##########################################"
echo "Be Careful this will override your Rice!! "
echo "##########################################"
echo
echo "Installing Necessary Packages"
echo "#############################"
echo
echo "Native Packages..."
echo
sudo pacman -S --noconfirm --needed kvantum unzip jq xmlstarlet fastfetch gtk-engine-murrine gtk-engines ttf-hack-nerd ttf-fira-code kdeconnect ttf-terminus-nerd noto-fonts-emoji ttf-meslo-nerd kde-wallpapers
echo
echo "AUR Packages..."
echo
# Check if yay is installed
if command -v yay &> /dev/null; then
    aur_helper="yay"
# Check if paru is installed
elif command -v paru &> /dev/null; then
    aur_helper="paru"
else
    echo "Neither yay nor paru is installed. Please install one of them."
    exit 1
fi
# Install packages using the detected AUR helper
$aur_helper -S --noconfirm --needed ttf-meslo-nerd-font-powerlevel10k oh-my-posh-bin
sleep 2
echo
echo "Creating Backup & Applying new Rice, hold on..."
echo "###############################################"
cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S) && cp -Rf Configs/Home/. ~
sudo cp -Rf Configs/System/. / && sudo cp -Rf Configs/Home/. /root/
sleep 2
echo
echo "Adding Fastfetch to your shell configuration"
echo

# Function to add fastfetch to a shell configuration file
add_fastfetch() {
  local shell_rc="$1"

  if ! grep -Fxq 'fastfetch' "$HOME/$shell_rc"; then
    echo '' >> "$HOME/$shell_rc"
    echo 'fastfetch' >> "$HOME/$shell_rc"
    echo
    echo "fastfetch has been added to your $shell_rc and will run on Terminal launch."
  else
    echo "fastfetch is already set to run on Terminal launch in $shell_rc."
  fi
}

# Detect the current shell
current_shell=$(basename "$SHELL")

# Prompt the user
read -p "Do you want to enable fastfetch to run on Terminal launch? (y/n): " response

case "$response" in
  [yY])
    if [ "$current_shell" = "zsh" ]; then
      add_fastfetch ".zshrc"
    elif [ "$current_shell" = "bash" ]; then
      add_fastfetch ".bashrc"
    else
      echo "Unsupported shell: $current_shell"
    fi
    ;;
  [nN])
    echo "fastfetch will not be added to your shell configuration."
    ;;
  *)
    echo "Invalid response. Please enter y or n."
    ;;
esac
sleep 2
echo
echo "Applying OhMy-Posh to Bash"
echo
# Check if the folder exists, if not create it and download the file
if [ ! -d "$HOME/.config/ohmyposh" ]; then
  mkdir -p "$HOME/.config/ohmyposh"
fi
curl -o "$HOME/.config/ohmyposh/tokyonight_storm.omp.json" https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/tokyonight_storm.omp.json
sleep 2
# Check if the line exists in ~/.bashrc, if not add it
if ! grep -Fxq 'eval "$(oh-my-posh init bash --config $HOME/.config/ohmyposh/tokyonight_storm.omp.json)"' "$HOME/.bashrc"; then
  echo '' >> "$HOME/.bashrc"
  echo 'eval "$(oh-my-posh init bash --config $HOME/.config/ohmyposh/tokyonight_storm.omp.json)"' >> "$HOME/.bashrc"
fi
echo
echo "Applying Grub Theme...."
echo "#######################"
chmod +x Grub.sh
sudo ./Grub.sh
sudo sed -i "s/GRUB_GFXMODE=*.*/GRUB_GFXMODE=1920x1080x32/g" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sleep 2
echo
echo "Installing Layan Theme"
echo "######################"
echo
cd ~ && git clone https://github.com/vinceliuice/Layan-kde.git && cd Layan-kde/ && sh install.sh
cd ~ && rm -Rf Layan-kde/
sleep 2
echo
echo "Installing & Applying GTK4 Theme "
echo "#################################"
cd ~ && git clone https://github.com/vinceliuice/Layan-gtk-theme.git && cd Layan-gtk-theme/ && sh install.sh -l -c dark
cd ~ && rm -Rf Layan-gtk-theme/
echo
echo "Installing Icon Pack"
echo "####################"
cd ~ && git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git && cd Tela-circle-icon-theme/
sudo chmod +x install.sh && sh install.sh -c purple
sleep 2
rm -rf ~/xero-layan-git/ ~/Tela-circle-icon-theme/
echo
echo "Plz Reboot To Apply Settings..."
echo "###############################"
