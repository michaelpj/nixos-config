{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    knownHosts = {
      zwrk = {
        extraHostNames = [ "x86_64-linux-1.zw3rk.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0gK7JFxEiGVltH5WuJq55Gvx0WiorntqEKkNkBBQfS";
      };
    };
    extraConfig = ''
      Host x86_64-linux-1.zw3rk.com
          User builder
          PubkeyAcceptedKeyTypes ssh-ed25519
          IdentityFile /root/.ssh/michaelpj
    '';
  };
}
