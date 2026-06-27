{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    knownHosts = {
      nixbuild = {
        extraHostNames = [ "eu.nixbuild.net" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
      };
    };
    extraConfig = ''
      Host eu.nixbuild.net
        # don't use any authentication mechanisms SSH expects (password, SSH keys, etc.)
        PreferredAuthentications none
        # log in as the 'authtoken' user
        # The token itself contains user information that nixbuild.net needs
        User authtoken
        # Auth token goes here, e.g.:
        #   SetEnv token=<your-nixbuild.net-biscuit-token>
        # Don't readFile a token from a tracked path — that bakes the secret
        # into the world-readable Nix store. Use a runtime secret (agenix/
        # sops-nix) or an out-of-store SetEnv if/when a personal token is needed.
    '';
  };
}
