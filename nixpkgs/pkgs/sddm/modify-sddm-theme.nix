{ writeText, runCommand, originalPackage, originalName, name, config, ... }:
let
  configFile = writeText "${name}.theme.conf.user" config;
in
runCommand name {} ''
  themedir=$out/share/sddm/themes/${name}
  mkdir -p $themedir
  ln -s -t $themedir ${originalPackage}/share/sddm/themes/${originalName}/*
  cp ${configFile} $themedir/theme.conf.user
''
