{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    knownHosts = {
      nixbuild = {
        extraHostNames = [ "eu.nixbuild.net" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
      };
    };
    # SSH version
    #extraConfig = ''
      #Host eu.nixbuild.net
          #PubkeyAcceptedKeyTypes ssh-ed25519
          #IdentityFile /root/.ssh/nixbuild
    #'';
    extraConfig = '' 
      Host eu.nixbuild.net
        # don't use any authentication mechanisms SSH expects (password, SSH keys, etc.)
        PreferredAuthentications none
        # log in as the 'authtoken' user
        # The token itself contains user information that nixbuild.net needs
        User authtoken
        # Send the 'token' environment variable from Nix to nixbuild.net in the SSH session.
        SetEnv token=${builtins.readFile ../secrets/mpj-io-biscuit-token}
    '';
  };
}
