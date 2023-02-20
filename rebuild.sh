#!/bin/sh
sudo nixos-rebuild --flake .\#`hostname` $1
home-manager --flake .\#`whoami`@`hostname` $1