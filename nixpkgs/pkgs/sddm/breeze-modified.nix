{ callPackage, plasma-workspace, ... }:
callPackage ./modify-sddm-theme.nix { 
  originalPackage = plasma-workspace.bin;
  originalName = "breeze";
  name = "breeze-modified"; 
  config = ''
    [General]
    color=#31363b  
  '';
}
