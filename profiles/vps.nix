{ domain ? "michaelpj.com", enableSsl ? true, ... }:
let
  # using an @ binding doesn't seem to work with optional args
  args = { inherit domain enableSsl; };
in
{ config, pkgs, ... }:
{
  imports = [
    (import ../modules/www.nix args)
    (import ../modules/hostedFiles.nix args)
    (../modules/basics.nix)
    (../modules/locales.nix)
    (../modules/users.nix)
  ];

  networking.domain = domain;

  services.nginx = {
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };
}
