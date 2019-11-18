{ config, pkgs, lib, ... }:
{
  environment.systemPackages = [ pkgs.direnv ];

  programs = {
    bash.interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
    zsh.interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
    '';
  };

  services.lorri.enable = true;
}

