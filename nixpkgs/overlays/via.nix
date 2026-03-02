self: super:

let
  teetty = super.rustPlatform.buildRustPackage rec {
    pname = "teetty";
    version = "0.4.0";

    src = super.fetchFromGitHub {
      owner = "mitsuhiko";
      repo = "teetty";
      rev = version;
      hash = "sha256-L5GlmbscAt6aqt79qq5UAeMeDscvpYUwjJZcSESMVj4=";
    };

    cargoHash = "sha256-fJ4TgQddr+OrvhSZFWcKyOvwkfBVQODHmq8E7nBOEZk=";

    # Tests require a real PTY which doesn't work in the Nix sandbox
    doCheck = false;

    meta = {
      description = "A bit like tee, a bit like script, but all with a fake tty. Lets you remote control and watch a process";
      homepage = "https://github.com/mitsuhiko/teetty";
      license = super.lib.licenses.asl20;
      mainProgram = "teetty";
    };
  };
in
{
  via = super.rustPlatform.buildRustPackage rec {
    pname = "via";
    version = "0.2.0";

    src = super.fetchFromGitHub {
      owner = "michaelpj";
      repo = "via";
      rev = "594dc91c1557143a8af900d8c5bec9f8165706db";
      hash = "sha256-lWr/XAsBiJ4MtVqWTaqd4rOadMBQZheqwUpL1275KnQ=";
    };

    cargoHash = "sha256-W9RY2wFCNqsDi+FaPXlYQqNcpAwrXGu/IzsoI/w+/ro=";

    nativeBuildInputs = [ super.makeWrapper ];

    postInstall = ''
      wrapProgram $out/bin/via \
        --prefix PATH : ${super.lib.makeBinPath [
          teetty
          super.coreutils
        ]}
    '';

    meta = {
      description = "Issue commands across multiple interactive CLI sessions";
      homepage = "https://github.com/rehno-lindeque/via";
      license = super.lib.licenses.asl20;
      mainProgram = "via";
    };
  };
}
