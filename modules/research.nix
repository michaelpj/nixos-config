{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zotero 
    # insecure?
    # xpdf
  ];
}
