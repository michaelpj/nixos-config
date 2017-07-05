{ config, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    firefox = {
     enableGoogleTalkPlugin = true;
     enableAdobeFlash = true;
    };
  };
}
