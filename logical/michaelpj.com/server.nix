let 
  parameters = import ./parameters.nix;
in 
{
  network.description = parameters.domain;

  server = 
    { config, pkgs, ... }:
    {
      imports = [ 
        (import ../../modules/www.nix parameters)
        (import ../../modules/blog.nix parameters)
        (import ../../modules/factorio.nix parameters)
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
