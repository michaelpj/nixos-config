{ domain, enableSsl }:
{ config, pkgs, ... }:
let 
  www = "www.${domain}";
in
{
  services.nginx.virtualHosts."${www}" = { 
    locations."/blog" = {
      alias = pkgs.callPackage ../../blog/build/default.nix {};
    };

    # redirect root to blog for now 
    extraConfig = "rewrite ^/$ /blog redirect;";
  };
}
