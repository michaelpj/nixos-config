{ config, pkgs, lib, ... }:

{
  imports = [ 
    ./circuithub/binary-cache.nix
    ./circuithub/tailscale.nix
    ./circuithub/rabbitmq.nix
    ./circuithub/1password.nix
  ];
}
