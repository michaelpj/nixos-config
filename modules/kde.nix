{ config, pkgs, ... }:
{
  services.xserver = {
    desktopManager.plasma5.enable = true;
    displayManager.sddm = {
      enable = true;
      theme = "breeze-modified";
    };
  };

  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ../nixpkgs/pkgs/sddm/breeze-modified.nix {})
  ];
}
