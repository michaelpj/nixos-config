{ config, pkgs, ... }:
{
  services.znc = {
    enable = true;
    mutable = false;
    confOptions = {
      nick = "michaelpj";
      # usual insecure pass
      passBlock = ''
        <Pass password>
                Method = sha256
                Hash = a49dcfe62df237e14b0a25a7fce06085123d48da527ca4e738a7ad59e806b3c4
                Salt = 3fuaJ,dQdUpmin/r+8wZ
        </Pass>
      '';
      networks.freenode = {
        port = 6697; 
        server = "chat.freenode.net"; 
        useSSL = true;
        channels = [ "nixos" "nixos-dev" ];
        modules = [ "simple_away" ];
      };
      extraZncConf = ''
        MaxBufferSize=10000
      '';
    };

  };

  networking.firewall.allowedTCPPorts = [ 5000 ];
}
