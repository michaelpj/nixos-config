{ domain, enableSsl, ... }:
{ config, pkgs, ... }:
let
  fqdn = "matrix.${domain}";
  enableACME = enableSsl;
  forceSSL = enableSsl;
  listenerPort = 8008;
in
{
  services.nginx = {
    enable = true;
    virtualHosts = {
      # virtual host for Matrix
      "${domain}" = {

        inherit enableACME forceSSL;
        listen = [
          { addr = "0.0.0.0"; port = 8448; ssl = true; }
          { addr = "[::]"; port = 8448; ssl = true; }
          { addr = "0.0.0.0"; port = 443; ssl = true; }
          { addr = "[::]"; port = 443; ssl = true; }
        ];

        locations."= /.well-known/matrix/server".extraConfig =
          let
            # use 443 instead of the default 8448 port to unite
            # the client-server and server-server port for simplicity
            server = { "m.server" = "${fqdn}:443"; };
          in ''
            add_header Content-Type application/json;
            return 200 '${builtins.toJSON server}';
          '';

  			locations."= /.well-known/matrix/client".extraConfig =
          let
            client = {
              "m.homeserver" =  { "base_url" = "https://${fqdn}"; };
              "m.identity_server" =  { "base_url" = "https://vector.im"; };
            };
          # ACAO required to allow element-web on any URL to request this json file
          in ''
            add_header Content-Type application/json;
            add_header Access-Control-Allow-Origin *;
            add_header Access-Control-Allow-Methods 'GET, POST, PUT, DELETE, OPTIONS';
            add_header Access-Control-Allow-Headers 'X-Requested-With, Content-Type, Authorization';
            return 200 '${builtins.toJSON client}';
          '';
      };

      "${fqdn}" = {
        inherit enableACME forceSSL;

        locations."/".extraConfig = ''
          return 404;
        '';

        locations."/_matrix".proxyPass = "http://[::1]:${builtins.toString listenerPort}";
      };
    };
  };

  services.matrix-synapse = {
    enable = true;
    settings = { 
      federation_domain_whitelist = [ "michaelpj.com" ];
      # domain for the Matrix IDs
      server_name = domain;
      # postgres is still a pain to set up with the right encodings...
      database.name = "sqlite3";
      # default http listener which nginx will passthrough to
      listeners = [
        {
					port = listenerPort;
					bind_addresses = [ "::1" ];
					type = "http";
					tls = false;
					x_forwarded = true;
					resources = [ {
						names = [ "client" ];
						compress = true;
					} {
						names = [ "federation" ];
						compress = false;
					} ];
				}
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    # "federation port"
    8448
    # "client port"
    443
  ];


}
