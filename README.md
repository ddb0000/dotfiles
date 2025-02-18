# Basic Nix Config

- run in this folder to apply configuration
 ```sh
 sudo nixos-rebuild switch --flake .
 ```

### Flake Structure and home.nix

This flake configuration uses Home Manager to manage user-specific settings. The `home.nix` file defines the user environment, including installed packages, window manager (Hyprland) configuration, and other personalized settings.

### Package Management

Packages are installed using the `home.packages` option. The configuration currently uses `pkgs` directly, TODO switching to `nixpkgs.legacyPackages.${system}.package_name` for more explicit package management.

### Hyprland Configuration

The `wayland.windowManager.hyprland` section configures the Hyprland window manager. This includes keybindings, settings, and autostart programs.

### Waybar Configuration

The `programs.waybar` section configures the Waybar status bar. This includes defining the modules to display and their settings.

### Hyprpaper Configuration

The `services.hyprpaper` section configures the Hyprpaper wallpaper manager. This includes setting the wallpaper image and interval.

### Hyprlock Configuration

The `programs.hyprlock` section configures the Hyprlock lock screen. This includes setting the background image, blur, and input field style.

### Secrets Management (TODO)

### Wallpaper Setting
Set using the `services.hyprpaper`option.

### References
https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager


# cmds
## Update:
nix flake update

## Rebuild:
nixos-rebuild switch --flake .

## Other user
# Deploy the flake.nix located in the current directory,
# with the nixosConfiguration's name `my-nixos`
sudo nixos-rebuild switch --flake .#my-nixos

# Deploy the flake.nix located at the default location (/etc/nixos)
sudo nixos-rebuild switch

# Viewing and Deleting Historical Data 
## Query all available historical versions 
nix profile history --profile /nix/var/nix/profiles/system
## Query Home manager generations
nix profile history --profile "$HOME/.local/state/nix/profiles/home-manager"

# Clean up historical versions and free up storage space

## Delete all historical versions older than 7 days
sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system

## Wiping history won't garbage collect the unused packages, you need to run the gc command manually as root:
sudo nix-collect-garbage --delete-old

## Due to the following issue, you ALSO need to run the gc command as per user to delete home-manager's historical data:
## https://github.com/NixOS/nix/issues/8508
nix-collect-garbage --delete-old