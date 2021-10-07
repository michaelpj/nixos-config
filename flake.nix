{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs?rev=bcd607489d76795508c48261e1ad05f5d4b7672f";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";

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
        ];
        specialArgs = { inherit nixos-hardware; };
      };
    };

  };
}
