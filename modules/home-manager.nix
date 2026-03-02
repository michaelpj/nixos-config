{ config, pkgs, codex-cli-nix, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = { inherit codex-cli-nix; };
  home-manager.users.michael = import ./home.nix;
}
