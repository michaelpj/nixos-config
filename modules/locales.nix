{ config, pkgs, ... }:

{
  console = {
    font = "lat9w-16";
    keyMap = "uk";
  };

  i18n = {
    defaultLocale = "en_GB.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.uk
  ];
}
