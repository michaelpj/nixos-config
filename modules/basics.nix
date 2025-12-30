{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim-full
    git
    tmux
    htop
    libnotify
  ];

  services = {
    # we always want to be able to ssh in
    openssh.enable = true;
  };

  # make sure we _can_ ssh in
  users.extraUsers.root.openssh.authorizedKeys.keyFiles = [ ../keys/laptop-standard.pub ];
}
