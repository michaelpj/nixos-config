{ stdenv, zip, jq, fetchFromGitHub, ... }:
let
  modDrv = { name, version, src, ... }: stdenv.mkDerivation rec {
    inherit name version src;
    deps = [];
    buildPhase = ''
      modname=$(${jq}/bin/jq -r .name < info.json) 
      modname+="_${version}"
      cd .. 
      # the zip needs to have a directory with the same name
      # as the top-level element
      mv "$sourceRoot" "$modname"
      ${zip}/bin/zip -r "$modname.zip" "$modname"
    '';
    installPhase = ''
      mkdir -p $out
      cp *.zip $out
    '';
  };
in
rec {
  collection = [ 
    helmod 
    bottleneck 
    squeak-through 
    upgrade-planner
  ];

  helmod = modDrv rec {
    version = "0.5.7";
    name = "helmod-${version}";
    src = fetchFromGitHub {
      owner = "Helfima";
      repo = "helmod";
      rev = version;
      sha256 = "0y3fpjvrbw9mryhg557cm26gk912780462msjmh63b71dp625lgb";
    };
  };

  bottleneck = modDrv rec {
    version = "0.8.5";
    name = "bottleneck-${version}";
    src = fetchFromGitHub {
      owner = "troelsbjerre";
      repo = "bottleneck";
      rev = "f09baf606713ff2e0b8db7703a58b5de656536d8";
      sha256 = "1w1q43iml8yk6fqm32m7s79n6fggk4ghp2xs11syj6ydb79v3yfh";
    };
  };

  squeak-through = modDrv rec {
    version = "1.1.7";
    name = "squeak-through-${version}";
    src = fetchFromGitHub {
      owner = "Suprcheese";
      repo = "Squeak-Through";
      rev = version;
      sha256 = "04l2x0mazmg2k2z0csnd201n8bjml40xyd308fx5rpj12lyvi9ap";
    };
  };

  upgrade-planner = modDrv rec {
    version = "1.3.7";
    name = "upgrade-planner-${version}";
    src = fetchFromGitHub {
      owner = "d3x0r";
      repo = "upgrade-planner";
      rev = version;
      sha256 = "1rcy2lx6rx5vdkcsggd0bb9hxdjfh24bg6m114nkxqk3ias427d5";
    };
  };
}
