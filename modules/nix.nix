{ config, pkgs, ... }:

{
  nix = {
    useSandbox = true;
    buildCores = 0;
    daemonNiceLevel = 1;
    daemonIONiceLevel = 1;
    trustedUsers = [ "@wheel" ];
  };
}
