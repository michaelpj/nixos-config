{ domain }:
{ config, pkgs, ... }:
let 
  factorio = "factorio.${domain}";
in
{
  nixpkgs.config.allowUnfree = true;

  services.factorio = {
    enable = true;
    game-name = factorio;
  };

  services.nginx.virtualHosts."${factorio}".locations."/".proxyPass = "http://localhost:${toString config.services.factorio.port}";
}
