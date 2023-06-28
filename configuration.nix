## il-mich Nixos config
#
#
#                `........`
#            .--::--------::.
#         .-:----------------:`
#       .:--------------------/
#      ::---------------------:-                        ``....`
#     :-----------------------:.                  .--:::-----:.
#    `/------------:::--------:                  ::-------:-+.
#    `:----------::...-::---::                `.:-------/h+.
#     /-------:::/-..-..::--:  ``          `.-:--:::-:+/.
#     .:-----/-...:./h/..::-/::::/.     `.-:-::-.`
#      `::---/-.+:.:::ys.-::/::---::---/:::-.`
#        `....--+ho/:::/:/::----:/:--::/.`
#              `-:+o---//-:/-sy+yho+/.
#              .:--+-::--//oso++++o/`
#              :-///:--:/---os+o/.
#              -://---/:----++++o:
#               -:---++/:::+o++++o/
#               +://oo+:-  ++++++++/
#               `--..      :+++++++o.
#                          +++++++++/
#                         -o+oooooo+o
#                         ++/:----://
#                        `/--------:`
#                       `+-//:::-:::
#                       .``.`.`.`.``

{ config, pkgs, ... }:

{
  # Include hardware scan results and contextual .nix configurations
  imports = [ 
    ./hardware-configuration.nix
    ./ricing.nix
  ];


  #              #
  ## BOOTLOADER ##
  #              #

  boot = {
    # Zen Kernel for responsiveness
    kernelPackages = pkgs.linuxPackages_zen;

    # Kernel parameters, noaer silences Active State Power Management errors
    kernelParams = [
      "quiet"
      "splash"
    ];

    # Add NTFS support
    supportedFilesystems = [
      "ntfs"
      "btrfs"
    ];

    loader = {
      # systemd-boot boot loader
      systemd-boot.enable = true;

      # Let the system modify EFI variables
      efi.canTouchEfiVariables = true;
    };
  };


  #              #
  ## NETWORKING ##
  #              #

  networking = {
    # Set hostname
    hostName = "nixed";

    # Use NetworkManager
    networkmanager.enable = true;

    # Explicitly disable firewall
    firewall.enable = false;
  };

  services = {
    avahi = {
      # Enable Avahi mDNS
      enable = true;

      # Avahi Name Service Switch (mDNS NSS)
      nssmdns = true;
    };
  };


  #          #
  ## SYSTEM ##
  #          #

  system = {
    # NixOS "release"
    stateVersion = "23.05";

    # Enable automatic system upgrades
    autoUpgrade.enable = true;
  };

  nix.gc = {
    # Enable automatic garbage collection
    automatic = true;

    # Time for the collection
    dates = "09:00";
  };

  # Allow nonfree software
  nixpkgs.config.allowUnfree = true;

  # Enable flatpak
  services.flatpak.enable = true;

  # Set time zone
  time.timeZone = "Europe/Rome";

  i18n = {
    # Set default language
    defaultLocale = "en_GB.UTF-8";

    # Set IT locale options
    extraLocaleSettings = {
      LC_ADDRESS = "it_IT.UTF-8";
      LC_IDENTIFICATION = "it_IT.UTF-8";
      LC_MEASUREMENT = "it_IT.UTF-8";
      LC_MONETARY = "it_IT.UTF-8";
      LC_NAME = "it_IT.UTF-8";
      LC_NUMERIC = "it_IT.UTF-8";
      LC_PAPER = "it_IT.UTF-8";
      LC_TELEPHONE = "it_IT.UTF-8";
      LC_TIME = "it_IT.UTF-8";
    };
  };

  # Use X server keymap
  console.useXkbConfig = true;

  # Personal account definition
  users.users.mich = {
    isNormalUser = true;
    passwordFile = "./mich-password.txt";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "dialout"
    ];
    packages = with pkgs; [
      bitwarden
      spotify
      gimp
      tdesktop
    ];
  };


  #            #
  ## HARDWARE ##
  #            #

  hardware = {
    # Update intel microcode
    cpu.intel.updateMicrocode = true;

    # Disable pulseaudio
    pulseaudio.enable = false;
  };

  # Enable sound
  sound.enable = true;

  services.pipewire = {
    # Use pipewire audio management
    enable = true;

    # Alsa replacement
    alsa = {
      enable = true;
      support32Bit = true;
    };

    # Pulseaudio replacement
    pulse.enable = true;
  };

  # Enable CUPS print framework
  services.printing.enable = true;

  # D-Bus secure scheduling
  security.rtkit.enable = true;


  #            #
  ## X SERVER ##
  #            #

  services = {
    xserver = {
      # Enable the X11 server
      enable = true;
  
      # Set Eurkey layout for X
      layout = "eu";
    };
  };


  #         #
  ## GNOME ##
  #         #

  services.xserver = {
    # Enable gdm
    displayManager.gdm.enable = true;

    # Use gnome as Desktop Manager
    desktopManager.gnome.enable = true;
  };

  services.gnome = {
    # Enable essential services for Gnome
    core-os-services.enable = true;

    # Enable Gnome utilities
    core-utilities.enable = true;

    # Add GLib network extensions
    glib-networking.enable = true;

    # Add Keyring
    gnome-keyring.enable = true;
  };

  # Remove unwanted Gnome software
  environment.gnome.excludePackages = with pkgs; [
    gnome.cheese
    gnome.epiphany
    gnome.geary
    gnome.yelp
    gnome.gnome-weather
    gnome.gnome-contacts
    gnome.gnome-maps
    gnome.gnome-music
    gnome.gnome-software
    gnome.gnome-shell-extensions
    gnome-tour
    gnome-console
  ];


  #               #
  ## ENVIRONMENT ##
  #               #

  environment = {
    # Shell aliases I need
    shellAliases = { ":q" = "exit"; };

    # Packages installed in system profile
    systemPackages = with pkgs; [
      alacritty
      bitwarden
      firefox
      gimp
      git
      helix
      jetbrains.pycharm-community
      microcodeIntel
      python310Full
      spotify
      tdesktop
      thunderbird
      unzip
      vlc
      wezterm
      wget
    ];
  };

  # Gnupg agent
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # OpenSSH server
  services.openssh.enable = true;
}
