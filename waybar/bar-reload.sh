#!/bin/sh

# This command sends a specific signal (SIGUSR2) to all running 'waybar' processes,
# which tells them to reload their configuration and styles.
killall -SIGUSR2 waybar
