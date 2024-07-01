{ ... }:

{
  nix.settings = {
    substituters = [ "https://cache.nixos.org s3://circuithub-nix-binary-cache?profile=circuithub-binary-cache&region=eu-central-1" ];
    trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= hydra.circuithub.com:tt5GsRxotmMj6nDFuiYGxKEWSZiDiywb0OEDdrfRXZk=" ];
  };
}
