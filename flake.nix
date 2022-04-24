{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware }: {

    packages."x86_64-linux" = 
      let pkgs = import nixpkgs { system = "x86_64-linux"; }; 
          blogStuff = pkgs.callPackage ./blog {};
      in {
        blog = blogStuff.blog;
        cv = pkgs.callPackage ./cv {};
      };

    nixosConfigurations = {
      clipper = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          (import ./machines/clipper/configuration.nix) 
          ({
              # Let 'nixos-version --json' know about the Git revision
              # of this flake.
              system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          })
          ({
              # For compatibility with other things, puts nixpkgs into NIX_PATH
              environment.etc.nixpkgs.source = nixpkgs;
              nix.nixPath = ["nixpkgs=/etc/nixpkgs"];
          })
        ];
        specialArgs = { inherit nixos-hardware; };
      };
    };

  };
}
