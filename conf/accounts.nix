{ config, pkgs, ... }:

{
  programs.zsh.enable = true;

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false; 

  users.users.michael = {
    description = "Michael Peyton Jones";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "vboxusers" ];
    shell = pkgs.zsh;
    uid = 1000;
    openssh.authorizedKeys.keyFiles = [ ../keys/github-mini.pub ];
  };
}
