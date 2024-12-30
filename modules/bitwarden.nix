{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.bitwarden-cli pkgs.bitwarden-desktop ];
}
