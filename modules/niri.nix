{ pkgs, lib, config, ... }:
{
  options = {
    niri.enable = lib.mkEnableOption "enable niri window manager";
  };

  config = lib.mkIf config.niri.enable {
    environment.variables = {
      # disable window decorations
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; 
      GTK_CSD = "true";
      # wayland
      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_SESSION_TYPE = "wayland";
      CLUTTER_BACKEND = "wayland";
    };
    
    programs = {
      seahorse.enable = true; # password app
      niri.enable = true;
    };
    
    environment.systemPackages = with pkgs; [
      # Wayland & Display Utilities
      wayland-utils
      wayland-scanner
      egl-wayland
      qt5.qtwayland
      qt6.qtwayland
      swww
      # Clipboard & Clipboard Management
      wl-clipboard
      cliphist
      xclip
      # Security & Authentication
      libsecret
      lxqt.lxqt-policykit
      # Media Tools
      mpv
      imv
      ffmpeg
      v4l-utils
      # Keyboard & Input Tools
      wev
      ydotool
      wtype
      # System Controls
      playerctl
      pavucontrol
      brightnessctl
    ];
    
    services = {
      gnome.gnome-keyring.enable = true;
      # display-manager
      displayManager = {
        enable = true;
        ly.enable = true;
        defaultSession = "niri";
      };
    };

    # security
    security = {
      rtkit.enable = true; # sound
      polkit.enable = true; # polkit
      polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        })
      '';
      pam.services.swaylock = {
        # locking
        text = ''
          auth include login
        '';
      };
    };

    # xdg portal
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      configPackages = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
