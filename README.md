# Basic Nix Config

## Update:
nix flake update

## Rebuild:
nixos-rebuild switch --flake .

# Updating the System
## Update flake.lock
nix flake update

## Or replace only the specific input, such as home-manager:
nix flake update home-manager

## Apply the updates
sudo nixos-rebuild switch --flake .

## Or to update flake.lock & apply with one command 
## (i.e. same as running "nix flake update" before)
sudo nixos-rebuild switch --recreate-lock-file --flake .


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