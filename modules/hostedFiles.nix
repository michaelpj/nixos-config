{ domain, enableSsl }:
{ config, pkgs, ... }:
let 
  www = "www.${domain}";
in
{
  services.nginx.virtualHosts."${www}" = { 
    locations."/files/cv.pdf" = {
      alias = ''${(pkgs.callPackage ../cv/default.nix {})}/cv.pdf'';
    };
  };
}
