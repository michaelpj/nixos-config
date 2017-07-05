{ config, pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
    ipv6 = true;
  };
}
