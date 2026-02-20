#!/bin/bash
set -e

SUDO_PASS="amjych"

echo "==============================================="
echo " NVIDIA 535xx Silent Installer (Arch Linux)"
echo "==============================================="

# --- Must NOT be run as root ---
if [[ $EUID -eq 0 ]]; then
  echo "❌ Do NOT run as root."
  exit 1
fi

# --- Ensure yay exists ---
if ! command -v yay >/dev/null 2>&1; then
  echo "❌ yay not found. Install yay first."
  exit 1
fi

# --- Kernel headers ---
echo "$SUDO_PASS" | sudo -S pacman -S --needed --noconfirm linux-headers

# --- NVIDIA legacy driver ---
yay -S --needed --noconfirm nvidia-535xx-utils
yay -S --needed --noconfirm nvidia-535xx-dkms
yay -S --needed --noconfirm nvidia-535xx-settings

# --- Regenerate initramfs ---
echo "$SUDO_PASS" | sudo -S mkinitcpio -P

echo "==============================================="
echo " ✅ INSTALL COMPLETE"
echo " 👉 Rebooting in 5 seconds..."
echo "==============================================="

sleep 5
echo "$SUDO_PASS" | sudo -S reboot