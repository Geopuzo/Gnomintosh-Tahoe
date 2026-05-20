#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting Gnomintosh-Tahoe environment installation..."

# 1. Update system and install base dependencies
echo "Installing system dependencies (sudo required)..."
sudo apt update
sudo apt install -y git curl wget perl cmake make sassc wmctrl \
                    gnome-tweaks gnome-shell-extension-manager dconf-editor

# 2. Create a temporary build directory
WORKDIR="$HOME/Downloads/tahoe_install"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# 3. Clone and install the main GNOME-macOS-Tahoe theme
echo "Cloning and installing the main macOS Tahoe theme..."
if [ -d "GNOME-macOS-Tahoe" ]; then
    rm -rf GNOME-macOS-Tahoe
fi
git clone https://github.com/kayozxo/GNOME-macOS-Tahoe.git
cd GNOME-macOS-Tahoe

# Run the official interactive installer for GTK and shell themes
chmod +x install.sh
./install.sh

# Apply the theme to modern Libadwaita (GTK4) applications
echo "Applying theme for Libadwaita (GTK4) applications..."
./install.sh -d -la  # This installs the dark version. Change -d to -l for the light version.

cd "$WORKDIR"

# 4. Clone and install the MacTahoe icon pack
echo "Cloning and installing the MacTahoe icon theme..."
if [ -d "MacTahoe-icon-theme" ]; then
    rm -rf MacTahoe-icon-theme
fi
git clone https://github.com/vinceliuice/MacTahoe-icon-theme.git
cd MacTahoe-icon-theme
chmod +x install.sh
./install.sh -q
cd "$WORKDIR"

# 5. Configure Flatpak compatibility
echo "Configuring Flatpak compatibility..."
sudo flatpak override --filesystem=xdg-config/gtk-3.0 || true
sudo flatpak override --filesystem=xdg-config/gtk-4.0 || true

# Clean up build files
rm -rf "$WORKDIR"

echo "Base installation completed successfully!"
echo "Please open the 'Extension Manager' application and enable:"
echo "   - Dash to Dock (or Dash to Dock Animated)"
echo "   - Blur my Shell"
echo "   - User Themes"
echo "After that, open 'Gnome Tweaks' and select the Tahoe theme under the 'Appearance' section."
