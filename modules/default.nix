{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # config options
    ./nvidia.nix
    ./niri.nix
    ./X11.nix
    # global
    ./system.nix
    ./theming.nix
  ];

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
     lazygit.enable = true;
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
    networkmanagerapplet

    # Compression & Archiving
    unrar
    unzip
    file-roller
    p7zip
    tree
    isoimagewriter
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
    # printing
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
    openssh.enable = true;
  };
}
