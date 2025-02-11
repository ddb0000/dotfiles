#!/bin/sh
pushd ~/.dotfiles
sudo nix-channel --update
popd
