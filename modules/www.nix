{ domain, enableSsl, ... }:
{ config, pkgs, ... }:
let 
  www = "www.${domain}";
  enableACME = enableSsl;
  forceSSL = enableSsl;
in
{
  # lets the webserver start so it can serve challenges
  security.acme = {
    acceptTerms = true;
    defaults.email = "me@michaelpj.com";
  };

  services.nginx = {
    enable = true;

    # Redirect bare domain to www
    # Note: doesn't do anything when deployed to testing
    virtualHosts."${domain}" = {
      inherit enableACME forceSSL;

      locations."/.well-known/".alias = "${../well-known}" + "/";
      locations."/" = {
        extraConfig = "return 301 $scheme://${www}$request_uri;";
      };
    };

    virtualHosts."${www}" = {
      # This makes things work nicely when we're not deployed to the real host, so
      # hostnames don't match
      default = true;
      inherit enableACME forceSSL;

      locations."/blog/".alias = (pkgs.callPackage ../blog/default.nix {}).blog + "/";
      locations."/".root = ../landing;
    };

    # not entirely sure why I need this, but nginx complains when deployed to virtd without it
    appendHttpConfig = "server_names_hash_bucket_size 64;";
  };

  networking.firewall.allowedTCPPorts = [ 80 ] ++ (if enableSsl then [ 443 ] else []);
}
