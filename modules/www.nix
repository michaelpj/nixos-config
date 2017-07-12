{ domain, enableSsl }:
{ config, pkgs, ... }:
let 
  www = "www.${domain}";
in
{
  # lets the webserver start so it can serve challenges
  security.acme.preliminarySelfsigned = enableSsl;

  services.nginx = {
    # Redirect bare domain to www
    # Note: doesn't do anything when deployed to testing
    virtualHosts."${domain}" = { 
      extraConfig = "return 301 $scheme://${www}$request_uri;";
    };

    virtualHosts."${www}" = { 
      # This makes things work nicely when we're not deployed to the real host, so
      # hostnames don't match
      default = true;
      enableACME = enableSsl;
      enableSSL = enableSsl;

      locations."/.well-known" = {
        alias = ../well-known;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ] ++ (if enableSsl then [ 443 ] else []);
}
