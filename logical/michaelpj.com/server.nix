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
        (import ../../modules/hostedFiles.nix args)
        (import ../../modules/matrix.nix args)
      ];

      networking.domain = domain;

      services.nginx = {
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
      };
    };
}
