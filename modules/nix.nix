{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    useSandbox = true;
    buildCores = 0;
    trustedUsers = [ "@wheel" ];
    binaryCaches = [ "https://cache.nixos.org/" ];
    extraOptions = ''
      builders-use-substitutes = true
      experimental-features = nix-command flakes
    '';
  };
}
