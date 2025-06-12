# Hyprland Dotfiles

## Installation

I'd recommend reading the install guide at [Hyprland](https://wiki.hypr.land/Getting-Started/Installation/) for getting a base configuration.

If you are using an NVIDIA GPU I'd also recommend reading the [NVIDIA](https://wiki.hypr.land/Nvidia/) specific tweaks though my setup is for an NVIDIA system.

## Getting my configurations

After you have [Hyprland](https://hypr.land) installed, you'll need the following dependencies:

- Foot (Terminal Emulator)

- Rofi Wayland (Menu/Launcher)

- Neovim (Editor)

- Zsh (Shell)

- Thunar (File Manager)

- Firefox (Web Browser)

- Hyprpaper (Wallpaper Selection)

- Hypr Polkit Agent (Authentication)

On Arch Linux you can run the following command:

`sudo pacman -S --needed - < pkglist.txt`

If you aren't using Arch Linux refer to your distribution's documentation as I am ONLY supporting Arch Linux.

## Final setup

For everything to work correctly you need to make some symbolic links for all the configurations to load:

```
ln -s ~/config/hypr/foot/foot.ini ~/.config/foot/foot.ini

ln -s ~/config/hypr/nvim/init.lua ~/.config/nvim/init.lua

ln -s ~/config/hypr/nvim/lua ~/.config/nvim/lua

ln -s ~/.config/hypr/rofi/config.rasi ~/.config/rofi/config.rasi

ln -s ~/.config/hypr/zshrc ~/.zshrc
```
