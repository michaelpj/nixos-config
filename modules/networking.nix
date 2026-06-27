{ config, pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;
    # Leave DNS to NetworkManager/Mullvad. Hardcoding a public resolver here
    # would send queries outside the VPN tunnel and defeat Mullvad's DNS-leak
    # protection.
    firewall.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish.enable = true;
    ipv6 = true;
    # mDNS needs UDP 5353 through the firewall.
    openFirewall = true;
  };
  services.mullvad-vpn = {
    enable = true;
  };
}
