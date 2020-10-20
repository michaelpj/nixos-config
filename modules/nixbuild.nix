{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    knownHosts = {
      nixbuild = {
        hostNames = [ "eu.nixbuild.net" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
      };
    };
    extraConfig = ''
      Host eu.nixbuild.net
          PubkeyAcceptedKeyTypes ssh-ed25519
          IdentityFile /root/.ssh/nixbuild
    '';
  };
}
