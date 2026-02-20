#!/bin/bash

# --- 1. INSTALL BUILD ESSENTIALS ---
# base-devel and git are required to build anything from the AUR
echo "Installing base-devel and git..."
sudo pacman -S --needed base-devel git --noconfirm

# --- 2. CLONE AND BUILD YAY ---
# We use a temporary folder in /tmp so it cleans itself up after a reboot
echo "Cloning yay from AUR..."
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay

# --- 3. MAKE AND INSTALL ---
# -s installs dependencies, -i installs the package, --noconfirm skips prompts
echo "Building and installing yay..."
makepkg -si --noconfirm

# --- 4. CLEANUP ---
echo "Cleaning up build files..."
cd ~
rm -rf /tmp/yay

echo "------------------------------------------------"
echo "Yay is now installed! You can now use 'yay -S package'"
echo "------------------------------------------------"
