#!/bin/sh
pushd ~/.dotfiles
nix-channel --update
popd
