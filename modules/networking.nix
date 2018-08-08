{ config, pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };

  services.resolved {
    enable = true;
    # too buggy, automatic downgrade doesn't seem to work properly
    dnssec = "false";
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
    ipv6 = true;
  };
}
