{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./GPU/nvidia.nix
    ./GPU/radeon.nix
  ];
  # ================================================================ #
  # =                           SYSTEM                             = #
  # ================================================================ #
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  # using tmpfs
  boot.tmp.useTmpfs = false;
  boot.tmp.tmpfsSize = "30%";

  boot.binfmt.registrations.appimage = {
    # appimage support
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

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

  # user
  users.users.goat = {
    isNormalUser = true;
    description = "goat";
    extraGroups = ["networkmanager" "wheel"];
  };

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
    fuse.userAllowOther = true; # user level programs
    seahorse.enable = true; # password app
    niri.enable = true;
  };

  # env packages
  environment.systemPackages = with pkgs; [
    # general utils
    ripgrep
    killall
    pciutils
    alejandra # nix language format
    nixd # language server
    # web utils
    wget
    git
    curl
    # files
    unrar
    unzip
    file-roller
    tree
    p7zip
    # wayland
    wayland-utils
    wayland-scanner
    egl-wayland
    qt5.qtwayland
    qt6.qtwayland
    networkmanagerapplet
    # clipboard
    wl-clipboard
    cliphist
    xclip
    # security
    libsecret
    lxqt.lxqt-policykit
    wlogout
    swayidle
    swaylock-effects
    # media
    mpv
    imv
    ffmpeg
    v4l-utils
    # keyboard
    wev
    ydotool
    wtype
    # media control
    playerctl
    pavucontrol
    brightnessctl
    # misc
    networkmanagerapplet
    appimage-run
  ];

  # ================================================================ #
  # =                         INFASTRUCTURE                        = #
  # ================================================================ #

  # theming
  stylix = {
    enable = true;
    homeManagerIntegration.autoImport = true;
    image = ../configs/wallpapers/clouds-sunset.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-city-terminal-dark.yaml";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Classic";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.noto-fonts-cjk-sans;
        name = "Noto Sans CJK";
      };
      serif = {
        package = pkgs.noto-fonts-cjk-serif;
        name = "Noto Serif CJK";
      };
      sizes = {
        applications = 12;
        terminal = 12;
        desktop = 11;
        popups = 12;
      };
    };
  };

  fonts.packages = [(pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})];

  # opengl option, renamed to graphics as of 24.11
  hardware.graphics.enable = true;

  # sound
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # printing
  services.printing.enable = true;

  # keyboard
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      displayManager= {
        lightdm.enable = false;
        sddm.wayland.enable = true;
        sddm.theme = "sddm-astronaut-theme";
        sddm.package = pkgs.sddm-astronaut; 
      }; 
    };
    libinput.enable = true;
  };

  # misc services
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    fstrim.enable = true;
    gnome.gnome-keyring.enable = true;
    openssh.enable = true;
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
  system.stateVersion = "24.05";
}
