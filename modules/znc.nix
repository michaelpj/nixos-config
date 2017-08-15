{ config, pkgs, ... }:
{
  services.znc = {
    enable = true;
    confOptions = {
      nick = "michaelpj";
      passBlock = ''
        <Pass password>
                Method = sha256
                Hash = 74d48ba1f186136e8002d3931a497ec707db7bef212646c9eaadde9a0f542524
                Salt = uggle86*ad-*xofu?Gk6
        </Pass>
      '';
      networks.freenode = {
        port = 6697; 
        server = "chat.freenode.net"; 
        useSSL = true;
        channels = [ "nixos" ];
      };
    };

  };

  networking.firewall.allowedTCPPorts = [ 5000 ];
}
