{ domain, ... }:
{ config, pkgs, ... }:
let 
  factorio = "factorio.${domain}";
in
{
  nixpkgs.config.allowUnfree = true;

  services.factorio = {
    enable = true;
    game-name = factorio;
    saveName = "railworld";
    mods = (pkgs.callPackage ../pkgs/factorio-mods.nix {}).collection;
  };

  services.nginx.virtualHosts."${factorio}".locations."/".proxyPass = "http://localhost:${toString config.services.factorio.port}";
}
