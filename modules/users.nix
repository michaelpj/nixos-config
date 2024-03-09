{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    # Set this explicitly to where e.g. zprezto expects it
    histFile = "$HOME/.config/zsh/.zhistory";
  };

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false; 

  users.users.michael = {
    description = "Michael Peyton Jones";
    isNormalUser = true;
    extraGroups = [ 
      "wheel" 
      "audio" "video"
      "systemd-journal"
      "networkmanager" 
      "vboxusers" 
      "libvirtd"
      "docker"
    ];
    shell = pkgs.zsh;
    uid = 1000;
    openssh.authorizedKeys.keyFiles = [ ../keys/laptop-standard.pub ];
  };
}
