{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    settings = {
      sandbox = true;
      cores = 0;
      trusted-users = [ "@wheel" ];
      substituters = [ "https://cache.nixos.org/" ];
      builders-use-substitutes = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
}
