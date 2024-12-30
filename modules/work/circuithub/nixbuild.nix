{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    knownHosts = {
      nxb-ch-trial = {
        extraHostNames = [ "ec2-44-209-63-204.compute-1.amazonaws.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHhhQI0rctOggRGf82iQzB9DTQk+4TkUPEIobuBiQlo";
      };
    };
    extraConfig = ''
      Host nxb-ch-trial
        Hostname ec2-44-209-63-204.compute-1.amazonaws.com
        Port 2222
        PubkeyAcceptedKeyTypes ssh-ed25519
        ServerAliveInterval 60
        IPQoS throughput
        IdentityFile /root/.ssh/circuithub-nixbuild-ssh
    '';
  };
}
