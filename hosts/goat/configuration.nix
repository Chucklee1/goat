{
  lib,
  config,
  ...
}:
# desktop conf
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default.nix
  ];
  # modules
  nvidia.enable = true;
  niri.enable = true;
  X11.enable = true;

  # hostname
  networking.hostName = "goat"; 

  # user account
  users.users.gaot = {
    isNormalUser = true;
    description = "goat";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  

  # ================================================================ #
  # =                         DO NOT TOUCH                         = #
  # ================================================================ #
  system.stateVersion = "24.05"; # D O  N O T  C H A N G E
}
