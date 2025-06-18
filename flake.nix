{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
      #url = "github:NixOS/nixpkgs?rev=0ce9de036c913724992384bdc4f3509f9409d959";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
    };
    nixinate = {
      url = "github:matthewcroughan/nixinate";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nixinate }: {


    packages."x86_64-linux" =
      let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        blogStuff = pkgs.callPackage ./blog { };
      in
      {
        blog = blogStuff.blog;
        cv = pkgs.callPackage ./cv { };
      };

    apps = nixinate.nixinate.x86_64-linux self;
    formatter."x86_64-linux" =
      let pkgs = import nixpkgs { system = "x86_64-linux"; };
      in pkgs.nixpkgs-fmt;

    nixosConfigurations =
      let
        revModule =
          {
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          };
        localNixpkgsModule =
          {
            # For compatibility with other things, puts nixpkgs into NIX_PATH
            environment.etc.nixpkgs.source = nixpkgs;
            nix.nixPath = [ "nixpkgs=/etc/nixpkgs" ];
          };
      in
      {
        clipper = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import ./machines/clipper/configuration.nix)
            (import ./profiles/dev.nix)
            revModule
            localNixpkgsModule
          ];
          specialArgs = { inherit nixos-hardware home-manager; };
        };
        schooner = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import ./machines/schooner/configuration.nix)
            (import ./profiles/dev.nix)
            revModule
            localNixpkgsModule
          ];
          specialArgs = { inherit nixos-hardware home-manager; };
        };
        vps = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (./machines/vultr/configuration.nix)
            (import ./profiles/vps.nix { })
            {
              _module.args.nixinate = {
                host = "michaelpj.com"; # "45.63.99.65";
                sshUser = "michael";
              };
            }
          ];
        };
      };
  };
}
