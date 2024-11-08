{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./GPU/nvidia.nix
    ./GPU/radeon.nix
    ./theming.nix
    ./user.nix
  ];

  # ================================================================ #
  # =                           SYSTEM                             = #
  # ================================================================ #

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  # tty settings
  console.font = "Lat2-Terminus16";
  console.useXkbConfig = true;

  # nix
  nixpkgs.config.allowUnfree = true;
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # idk
  networking.hostName = "goat";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_CA.UTF-8";

  # ================================================================ #
  # =                            SOFTWARE                          = #
  # ================================================================ #

  # file manager
  programs = {
    thunar.enable = true;
    thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
    # fuse.userAllowOther = true; # user level programs
    seahorse.enable = true; # password app
    lazygit.enable = true;
    niri.enable = true;
  };

  # env packages
  environment.systemPackages = with pkgs; [
    # Development Tools
    ripgrep
    alejandra
    nixd
    libgccjit
    rustc

    # Command-Line Utilities
    killall
    pciutils
    sl
    cowsay
    neofetch

    # Web & Networking Utilities
    wget
    git
    curl

    # Compression & Archiving
    unrar
    unzip
    file-roller
    p7zip
    tree
    isoimagewriter

    # Wayland & Display Utilities
    wayland-utils
    wayland-scanner
    kdePackages.kwin
    egl-wayland
    qt5.qtwayland
    qt6.qtwayland
    networkmanagerapplet
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

  # ================================================================ #
  # =                         INFASTRUCTURE                        = #
  # ================================================================ #

  # hardware
  hardware = {
    # opengl option, renamed to graphics as of 24.11
    graphics.enable = true;
    # bluetooth
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    # disable pulse audio
    pulseaudio.enable = false;
  };

  # services
  services = {
    # keyboard
    printing.enable = true;
    # bluetooth applet
    blueman.enable = true;
    # sound
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    # misc services
    gvfs.enable = true;
    tumbler.enable = true;
    fstrim.enable = true;
    gnome.gnome-keyring.enable = true;
    openssh.enable = true;
    libinput.enable = true;
    # display-manager
    displayManager = {
      enable = true;
      defaultSession = "niri";
      sddm = {
        enable = true;
        wayland.enable = true;
        wayland.compositor = "kwin";
        autoNumlock = true;
      };
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

  # ================================================================ #
  # =                         DO NOT TOUCH                         = #
  # ================================================================ #
  system.stateVersion = "24.05"; # D O  N O T  C H A N G E
}
