{ config, pkgs, ... }:
{
  services.openvpn.servers = {
    semmle = {
      config = ''
        client
        dev tap

        remote vpn.semmle.com 1194 udp

        nobind
        compress lzo
        persist-tun
        persist-key

        # need to be manually installed on the machine
        # not in nix store because they're secret
        ca /root/.vpn/semmle/ca.crt
        cert /root/.vpn/semmle/cert.crt
        key /root/.vpn/semmle/key.key
      '';
      updateResolvConf = true; 
      autoStart = false;
    };
  };
}
