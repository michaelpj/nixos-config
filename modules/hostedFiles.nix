{ domain, enableSsl }:
{ config, pkgs, ... }:
let 
  www = "www.${domain}";
  # this should join all the files together in future when there are more
  files = pkgs.callPackage ../cv/default.nix {};
in
{
  services.nginx.virtualHosts."${www}" = { 
    locations."/files/".alias = files + "/";
  };
}
