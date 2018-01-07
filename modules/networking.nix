{ config, pkgs, ... }:

{
  networking = {
    connman.enable = true;
    firewall.enable = false;
  };

  environment.systemPackages = [ pkgs.cmst ];

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
    ipv6 = true;
  };
}
