{ config, pkgs, ... }:

{
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  environment.systemPackages = [
    aspell
    aspellDicts.en
    aspellDicts.uk
  ];
}
