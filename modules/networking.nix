{ config, pkgs, ... }:

{
  networking = {
    networkmanager = { 
      enable = true;
      # I am confused about whether I need this as well as
      # networking.nameservers
      appendNameservers = [ "8.8.8.8" ]; 
    };
    firewall.enable = false;
    nameservers = [ "8.8.8.8" ];

  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish.enable = true;
    ipv6 = true;
  };
}
