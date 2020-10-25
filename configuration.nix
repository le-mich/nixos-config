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
    ./vscode.nix
    ./ricing.nix
    ./TSP.nix
  ];


  #              #
  ## BOOTLOADER ##
  #              #

  boot = {
    # Add NTFS support
    supportedFilesystems = [ "ntfs" ];

    # Kernel parameters, noaer silences Active State Power Management errors
    kernelParams = [
      "quiet"
      "splash"
      "pci=noaer"
    ];

    loader = {
      grub = {
        # Use Grub v2
        enable = true;
        version = 2;

        # Enable efi support for Grub
        efiSupport = true;

        # Don't install Grub on devices
        device = "nodev";

        # Add Windows 10 entry
        extraEntries = ''
          menuentry "Windows 10" {
            insmod part_gpt
            insmod fat
            insmod search_fs_uuid
            insmod chain
            search --fs-uuid --set=root CEC9-765E
            chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
      };

      efi = {
        # Let the system modify EFI variables
        canTouchEfiVariables = true;

        # Set the correct mountpoint
        efiSysMountPoint = "/boot/efi";
      };
    };
  };


  #              #
  ## NETWORKING ##
  #              #

  networking = {
    # Set hostname
    hostName = "momi-pls";

    # The global useDHCP flag is deprecated and explicitly set to false
    useDHCP = false;
 
    interfaces = {
      # Per-interface useDHCP
      enp2s0.useDHCP = true;
      wlp3s0.useDHCP = true;
    };

    networkmanager = {
      # Use NetworkManager
      enable = true;

      # Activate NetworkManager WiFi powersave
      wifi.powersave = true;
    };
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
    stateVersion = "20.03";

    # Enable automatic system upgrades
    autoUpgrade.enable = true;
  };

  # Allow nonfree software
  nixpkgs.config.allowUnfree = true;

  # Set time zone
  time.timeZone = "Europe/Rome";

  # Set default locale
  i18n.defaultLocale = "en_GB.UTF-8";

  # Use X server keymap
  console.useXkbConfig = true;

  users = {
    # Personal account definition
    users.mich = {
      isNormalUser = true;
      passwordFile = "./mich-password.txt";
      uid = 1000;
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
      ];
    };

    # Set GID for group users
    groups.users.gid = 100;
  };


  #            #
  ## HARDWARE ##
  #            #

  hardware = {
    # Update intel microcode
    cpu.intel.updateMicrocode = true;

    # Disable discrete GPU completely (?)
    nvidiaOptimus.disable = true;

    # Use pulseaudio audio management
    pulseaudio.enable = true;

    # Enable brightness control with xbacklight
    acpilight.enable = true;

    # Add bluetooth hardware support
    bluetooth.enable = true;
  };

  # Enable sound
  sound.enable = true;

  # Enable CUPS print framework
  services.printing.enable = true;

  # Mount NTFS drive as rw in /home/mich
  fileSystems."/home/mich" = {
    device = "/dev/disk/by-uuid/01D3E3A71D5464B0";
    fsType = "ntfs";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "umask=0022"
    ];
  };


  #            #
  ## X SERVER ##
  #            #

  services.xserver = {
    # Enable the X11 server
    enable = true;
  
    # Set it layout for X
    layout = "it";
    xkbOptions = "eurosign:e";

    libinput = {
      # Enable touchpad
      enable = true;

      # Set natural scrolling for libinput
      naturalScrolling = true;
    };

    # Select video drivers
    videoDrivers = [ "intel" ];
  };


  #         #
  ## GNOME ##
  #         #

  services.xserver = {
    # Enable gdm
    displayManager.gdm.enable = true;

    # Use gnome3 as Desktop Manager
    desktopManager.gnome3.enable = true;
  };

  services.gnome3 = {
    # Enable essential services for Gnome
    core-os-services.enable = true;

    # Enable Gnome utilities
    core-utilities.enable = true;

    # Add GLib network extensions
    glib-networking.enable = true;
  };

  # Remove unwanted Gnome software
  environment.gnome3.excludePackages = [
    pkgs.gnome3.cheese
    pkgs.gnome3.epiphany
    pkgs.gnome3.geary
    pkgs.gnome3.gedit
    pkgs.gnome3.gnome-contacts
    pkgs.gnome3.gnome-maps
    pkgs.gnome3.gnome-music
    pkgs.gnome3.gnome-software
  ];


  #               #
  ## ENVIRONMENT ##
  #               #

  # Vim as default
  programs.vim.defaultEditor = true;

  environment = {
    # Shell aliases I need
    shellAliases = { ":q" = "exit"; };

    # Packages installed in system profile
    systemPackages = with pkgs; [
      microcodeIntel
      firefox
      spotify
      vlc
      gimp
      powertop
      wget
      tdesktop
      python3
      numlockx
    ];
  };
}
