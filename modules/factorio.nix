{ domain, ... }:
{ config, pkgs, ... }:
let 
  factorio = "factorio.${domain}";
  factorio-mods = (pkgs.callPackage ../nixpkgs/factorio-mods.nix {}).collection;
in
{
  nixpkgs.config.allowUnfree = true;

  services.factorio = {
    enable = true;
    game-name = factorio;
    saveName = "railworld";
    mods = factorio-mods;
  };

  services.nginx.virtualHosts."${factorio}" = {
    locations."/".proxyPass = "http://localhost:${toString config.services.factorio.port}";
    # serve the mods as a directory
    locations."/mods" = {
      # inconveniently replicating what's in the package, but easiest way to
      # get it out
      alias = pkgs.factorio-utils.mkModDirDrv factorio-mods;
      extraConfig = "autoindex on;";
    };
  };
}
