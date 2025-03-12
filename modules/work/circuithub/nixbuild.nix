{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    extraConfig = ''
      Host ch-nixbuild
        Hostname 18.210.169.118
        Port 2222
        PubkeyAcceptedKeyTypes ssh-ed25519
        ServerAliveInterval 60
        IPQoS throughput
    '';
    knownHosts = {
      "ch-nixbuild" = {
        extraHostNames = [ "18.210.169.118" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGrwGIHzDfEpg8ja2U6d+TdCxENwo4aZQqjaw+KyFQqB";
      };
    };
  };
}
