{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim_configurable git tmux htop 
  ];

  services = {
    # we always want to be able to ssh in
    openssh.enable = true;
  };

  # make sure we _can_ ssh in
  users.extraUsers.root.openssh.authorizedKeys.keyFiles = [ ../../keys/laptop-standard.pub ];
}
