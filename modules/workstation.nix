{ config, pkgs, ... }:

{
  boot.tmpOnTmpfs = true;

  networking.firewall.checkReversePath = false;

  services = {
    printing.enable = true;
  };

  programs = {
    # want to remember keys on here
    ssh.startAgent = true;
    hamster.enable = true;
  };
}
