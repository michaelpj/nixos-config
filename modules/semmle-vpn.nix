{ config, pkgs, ... }:
{
  services.openvpn.servers = {
    semmle = {
      config = ''
        client
        dev tun

        remote oxford-vpn.semmle.com 1194 udp
        verify-x509-name oxford-vpn.semmle.com name

        nobind
        compress lzo
        persist-tun
        persist-key

        # need to be manually installed on the machine
        # not in nix store because they're secret
        ca /root/.vpn/semmle/ca.crt
        cert /root/.vpn/semmle/cert.crt
        key /root/.vpn/semmle/key.key
        tls-auth /root/.vpn/semmle/ta.key 1

        dhcp-option DOMAIN internal.semmle.com
        dhcp-option DOMAIN semmle.com

        cipher AES-256-CBC
        auth SHA256
        tls-version-min 1.2
      '';
      updateResolvConf = true; 
      autoStart = false;
    };
  };
}
