{ config, pkgs, ... }:

{
  nix = {
    settings = {
      sandbox = true;
      cores = 0;
      trusted-users = [ "@wheel" ];
      substituters = [ "https://cache.nixos.org/" ];
      builders-use-substitutes = true;
      experimental-features = [ "nix-command" "flakes" "impure-derivations" "ca-derivations" ];
    };
  };
}
