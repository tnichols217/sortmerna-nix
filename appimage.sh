#!/usr/bin/env bash

nix bundle --experimental-features "nix-command flakes" --bundler github:ralismark/nix-appimage .#sortmerna
