{ domain ? "michaelpj.com", enableSsl ? true, ... }:
let
  # using an @ binding doesn't seem to work with optional args
  args = { inherit domain enableSsl; };
in
{
  network.description = domain;

  server = 
    { config, pkgs, ... }:
    {
      imports = [ 
        (import ../../modules/www.nix args)
        (import ../../modules/znc.nix)
        (import ../../modules/hostedFiles.nix args)
      ];

      services.nginx = {
        enable = true;

        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
      };
    };
}
