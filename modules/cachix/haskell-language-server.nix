
{
  nix.settings = {
    substituters = [
      "https://haskell-language-server.cachix.org"
    ];
    trusted-public-keys = [
      "haskell-language-server.cachix.org-1:juFfHrwkOxqIOZShtC4YC1uT1bBcq2RSvC7OMKx0Nz8="
    ];
  };
}
