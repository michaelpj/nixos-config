{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ ktailctl ];
  services.tailscale.enable = true;

  # ktailctl talks directly to the tailscaled local API socket. The socket is
  # world-accessible for read-only queries, but management operations (up/down,
  # exit nodes, etc.) require the caller to be root or the registered "operator".
  # Register michael as the operator so ktailctl can manage tailscale without
  # elevation. This runs `tailscale set --operator=michael` as root on boot.
  services.tailscale.extraSetFlags = [ "--operator=michael" ];
}
