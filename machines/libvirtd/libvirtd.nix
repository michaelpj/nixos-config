{
  server = 
    { config, pkgs, ... }:
    {
      deployment.targetEnv = "libvirtd";
      deployment.libvirtd.headless = true;
    };
}
