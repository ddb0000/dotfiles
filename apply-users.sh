#!/bin/sh
pushd ~/.dotfiles
home-manager switch -f ./users/dan/home.nix
popd
