{ config, pkgs, llm-agents-nix, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = { inherit llm-agents-nix; };
  home-manager.users.michael = import ./home.nix;
}
