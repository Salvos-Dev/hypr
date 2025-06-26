#!/bin/sh

# --- Set your wallpaper ---
# We start this first so the wallpaper is immediately visible.
hyprpaper &

# --- Start display management ---
# Start kanshi to configure monitors and wait for it to finish.
kanshi &
sleep 2

# --- Set up the D-Bus environment ---
# This is now guaranteed to run *after* kanshi has settled.
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# --- Start other services ---
# These can now launch safely.
dunst &
systemctl --user start hyprpolkitagent &
waybar &
