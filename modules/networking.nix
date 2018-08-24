{ config, pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
    nameservers = [ "8.8.8.8" ];
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
    ipv6 = true;
  };
}
