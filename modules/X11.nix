{ pkgs, lib, config, ... }:

{
  options = {
    X11.enable = lib.mkEnableOption "enable various X11 desktop managers";
  };

  config = lib.mkIf config.X11.enable {
    services.xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      desktopManager.pantheon.enable = true;
      xkb.layout = "us";
    };
    environment.systemPackages = [ pkgs.pantheon-tweaks ];
  };
}
