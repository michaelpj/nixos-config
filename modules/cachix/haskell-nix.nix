# Binary cache for haskell.nix (IOG's Haskell infrastructure). Without this,
# haskell.nix projects rebuild GHC and large dependency closures from source.
# The cache is served from IOG and still uses the legacy `hydra.iohk.io` key
# name even though the substituter URL is now `cache.iog.io`.
{ ... }:

{
  nix.settings = {
    substituters = [ "https://cache.iog.io" ];
    trusted-public-keys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
  };
}
