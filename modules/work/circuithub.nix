{ config, pkgs, lib, ... }:

{
  imports = [
    ./circuithub/binary-cache.nix
    ./circuithub/tailscale.nix
    ./circuithub/rabbitmq.nix
    ./circuithub/nixbuild.nix
  ];
}
