{ domain ? "michaelpj.com", enableSsl ? true, ... }:
let
  args = { inherit domain enableSsl; };
in
{ config, pkgs, ... }:
{
  imports = [
    ./base.nix
    (import ../modules/www.nix args)
    (import ../modules/hostedFiles.nix args)
  ];

  networking.domain = domain;

  services.nginx = {
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };
}
