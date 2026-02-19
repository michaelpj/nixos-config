self: super:

let
  pname = "donethat";
  version = "1.4.8";
  src = super.fetchurl {
    url = "https://github.com/donethatai/donethat-releases/releases/download/v${version}/DoneThat-x86_64.AppImage";
    hash = "sha256-J2xa4MQoMli9+INZBG7Se/mZN44xU+N3+D6bLrd0Znk=";
  };
in
{
  donethat = super.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands =
      let
        appimageContents = super.appimageTools.extractType2 { inherit pname version src; };
      in
      ''
        # Install icons
        mkdir -p $out/share
        cp -r ${appimageContents}/usr/share/icons $out/share/icons

        # Install desktop file with corrected Exec and visibility
        install -Dm444 ${appimageContents}/donethat.desktop -t $out/share/applications/
        substituteInPlace $out/share/applications/donethat.desktop \
          --replace-quiet 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U' \
          --replace-quiet 'NoDisplay=true' 'NoDisplay=false'
      '';

    meta = with super.lib; {
      description = "DoneThat - AI-powered daily standup and progress tracking";
      homepage = "https://donethat.ai";
      license = licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  };
}
