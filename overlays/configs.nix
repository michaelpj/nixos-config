self: super:
let
  factorio-secrets = import ../secrets/factorio.nix;
in
{

  factorio = super.factorio.override {
    username = factorio-secrets.username;
    password = factorio-secrets.password;
    mods = with super.callPackage ../pkgs/factorio-mods.nix {}; [ 
      helmod 
      bottleneck 
      squeak-through 
      upgrade-planner
    ];
  };

}
