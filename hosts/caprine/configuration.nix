{
  lib,
  config,
  ...
}:
# macbook conf
{
  imports =
    [ 
      ./hardware-configuration.nix
      ../../modules/default.nix
    ];
  # modules
  nvidia.enable = false;
  niri.enable = false;
  X11.enable = true;
  
  # hostname
  networking.hostName = "caprine"; 
  
  # user account
  users.users.caprine = {
    isNormalUser = true;
    description = "caprine";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  
  # ================================================================ #
  # =                         DO NOT TOUCH                         = #
  # ================================================================ #
  system.stateVersion = "24.05"; # D O  N O T  C H A N G E

}
