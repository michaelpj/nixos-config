{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zotero 
    # insecure?
    # xpdf
  ];
}
