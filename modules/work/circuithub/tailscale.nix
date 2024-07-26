{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ktailctl];
  services.tailscale.enable = true;
}
