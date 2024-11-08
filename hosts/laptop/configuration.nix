{
  lib,
  config,
  ...
}:
# laptop conf
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default.nix
  ];
  
  services.libinput.enable = true;

  nvidia.enable = false;
  radeon.enable = false;
}
