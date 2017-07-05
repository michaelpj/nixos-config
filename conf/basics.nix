{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim_configurable git tmux htop 
  ];

  services.openssh.enable = true;
}
