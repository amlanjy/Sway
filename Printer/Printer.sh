#!/bin/bash

# --- 1. CORE SYSTEM DEPENDENCIES ---
# Installs the printing engine and KDE's configuration tools
echo "Installing CUPS and system support packages..."
sudo pacman -S --needed cups cups-filters ghostscript foomatic-db foomatic-db-engine system-config-printer

# --- 2. AUR DRIVERS & UTILITIES ---
# Uses yay to pull the specific 202101w driver and scanner tools
echo "Installing Epson drivers and scanner software from AUR..."
yay -S --needed epson-inkjet-printer-202101w epsonscan2 epsonscan2-non-free-plugin epson-printer-utility

# --- 3. SERVICE ACTIVATION ---
# Enables the printing service so it starts now and on every boot
echo "Activating CUPS service..."
sudo systemctl enable --now cups

# --- 4. THE 'ARCH FIX' (SYMLINK) ---
# Maps the driver filter to the correct directory so it doesn't stay 'Idle'
echo "Applying the filter path fix..."
sudo ln -sf /opt/epson-inkjet-printer-202101w/cups/lib/filter/epson_printer_filter /usr/lib/cups/filter/epson_printer_filter

# --- 5. PERMISSIONS ---
# Adds your user to the 'lp' group so you can manage printer settings without sudo
echo "Updating user permissions..."
sudo usermod -aG lp $USER

echo "----------------------------------------------------"
echo "SETUP COMPLETE!"
echo "1. Open KDE System Settings > Printers"
echo "2. Add your Epson L3210/3216"
echo "3. Ensure 'Connection' is set to your USB port, not /dev/null"
echo "----------------------------------------------------"