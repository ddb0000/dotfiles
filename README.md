# Basic Nix Config

- run in this folder to apply configuration
 ```sh
 sudo nixos-rebuild switch --flake .
 ```


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

# Clean up historical versions and free up storage space

## Delete all historical versions older than 7 days
sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system

## Wiping history won't garbage collect the unused packages, you need to run the gc command manually as root:
sudo nix-collect-garbage --delete-old

## Due to the following issue, you need to run the gc command as per user to delete home-manager's historical data:
## https://github.com/NixOS/nix/issues/8508
nix-collect-garbage --delete-old