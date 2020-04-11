{ domain, enableSsl, ... }:
{ config, pkgs, ... }:
let
  matrix = "matrix.${domain}";
  riot = "riot.${domain}";
  enableACME = enableSsl;
  forceSSL = enableSsl;
  listenerPort = 8008;
in
{
  services.nginx = {
    enable = true;
    virtualHosts = {
      # virtual host for Matrix
      "${matrix}" = {
        inherit enableACME forceSSL;
        listen = [
          { addr = "0.0.0.0"; port = 8448; ssl = true; }
          { addr = "[::]"; port = 8448; ssl = true; }
          { addr = "0.0.0.0"; port = 443; ssl = true; }
          { addr = "[::]"; port = 443; ssl = true; }
        ];

        locations."/".proxyPass = "http://[::1]:${builtins.toString listenerPort}";
      };

      # virtual host for Riot/Web
      #"${riot}" = {
        #inherit enableACME forceSSL;

        ## root points to the riot-web package content
        #locations."/" = {
            #root = pkgs.riot-web;
        #};
      #};
    };
  };

  services.matrix-synapse = {
    enable = true;
    # domain for the Matrix IDs
    server_name = domain;
    # enable metrics collection
    enable_metrics = true;
    # enable user registration
    enable_registration = true;
    # postgres is still a pain to set up with the right encodings...
    database_type = "sqlite3";
    # default http listener which nginx will passthrough to
    listeners = [
      {
        port = listenerPort;
        tls = false;
        resources = [
          {
            compress = true;
            names = ["client" "federation"];
          }
        ];
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [
    # "federation port"
    8448
    # "client port"
    443
  ];


}
