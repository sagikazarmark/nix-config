#!/bin/sh

gsettings set org.gnome.mutter overlay-key ''
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
gsettings set org.gnome.desktop.peripherals.keyboard delay 225

gsettings set org.gnome.desktop.wm.keybindings minimize '@as []'
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>w']"

gsettings set org.gnome.desktop.peripherals.mouse natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
