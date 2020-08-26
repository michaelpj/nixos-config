{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim_configurable git tmux htop 
  ];

  services = {
    # we always want to be able to ssh in
    openssh.enable = true;
    # just more sensible
    dbus.socketActivated = true;
  };
}
