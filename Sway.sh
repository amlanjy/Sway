#!/bin/bash

# --- 1. Sudo Keep-Alive ---
# Ask for password once at the start.
sudo -v

echo "Starting fully automatic installation with NVIDIA and Printer support..."

# --- 2. Install Dependencies & Yay ---
if ! command -v yay &> /dev/null; then
    echo "Yay not found. Installing yay-bin..."
    sudo pacman -S --needed --noconfirm git base-devel
    # Ensure clean workspace in /tmp
    rm -rf /tmp/yay-bin
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin
    # makepkg MUST NOT be run with sudo
    makepkg -si --noconfirm
    cd -
fi

# --- 3. NVIDIA 535xx LEGACY SETUP ---
echo "Configuring NVIDIA legacy drivers..."
# Headers are required for DKMS modules to build 
sudo pacman -S --needed --noconfirm linux-headers 
yay -S --needed --noconfirm --sudoloop nvidia-535xx-utils nvidia-535xx-dkms nvidia-535xx-settings 
# Apply drivers to initramfs
sudo mkinitcpio -P

# --- 4. PRINTER & EPSON SETUP ---
echo "Installing CUPS and Epson support..."
sudo pacman -S --needed --noconfirm cups cups-filters ghostscript foomatic-db foomatic-db-engine system-config-printer 
yay -S --needed --noconfirm --sudoloop epson-inkjet-printer-202101w epsonscan2 epsonscan2-non-free-plugin epson-printer-utility 

# Activate printing services
sudo systemctl enable --now cups
# Add user to printer group (lp)
sudo usermod -aG lp $USER
# Arch-specific filter path fix for Epson drivers 
sudo ln -sf /opt/epson-inkjet-printer-202101w/cups/lib/filter/epson_printer_filter /usr/lib/cups/filter/epson_printer_filter

# --- 5. INSTALL MAIN SYSTEM PACKAGES ---
echo "Installing main system packages..."
sudo pacman -S --needed --noconfirm \
    base base-devel sudo pacman-contrib \
    linux linux-firmware intel-ucode acpi brightnessctl usbutils \
    sway swaybg swaync waybar waypaper rofi greetd \
    kitty starship fastfetch bat micro htop \
    thunar ark android-file-transfer android-udev gvfs-mtp unzip \
    firefox networkmanager network-manager-applet wpa_supplicant dnsmasq \
    vlc celluloid mpd pavucontrol pipewire-pulse \
    gimp gthumb libreoffice-still mupdf \
    ttf-jetbrains-mono-nerd ttf-roboto ttf-dejavu ttf-liberation gsfonts \
    bluez bluez-utils blueman \
    grim wl-clipboard xdg-desktop-portal-gtk xdg-desktop-portal-wlr xorg-xwayland 

# --- 6. INSTALL REMAINING AUR PACKAGES ---
echo "Installing additional AUR packages..."
yay -S --needed --noconfirm --sudoloop \
    greetd-tuigreet \
    localsend \
    ttf-ms-fonts \
    woff2-font-awesome 

# --- 7. ENABLE SERVICES ---
echo "Enabling core services..."
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable greetd

echo "--------------------------------------------------"
echo "INSTALLATION COMPLETE!"
echo "Rebooting in 10 seconds..."
echo "--------------------------------------------------"
sleep 10
sudo reboot
