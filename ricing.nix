{ config, pkgs, ... }:

{
  #              #
  ## BOOTLOADER ##
  #              #

  # Plymouth splash screen with default values
  boot.plymouth.enable = true;


  #         #
  ## GNOME ##
  #         #

  services.gnome = {
    # Add Gnome Shell services
    core-shell.enable = true;
 
    # Enable Chrome Gnome Shell host connector to install extensions
    gnome-browser-connector.enable = true;
  };

  # Qt like Gnome
  qt.platformTheme = "gnome";


  #        #
  ## HYPR ##
  #        #

  programs.hyprland = {
    # Enable Hyprland
    enable = true;

    # xwayland compatibility layer
    xwayland.enable = true;

    # patches for nvidia driver
    nvidiaPatches = true;
  };


  #         #
  ## FONTS ##
  #         #

  fonts = {
    # Install fonts
    fonts = with pkgs; [
      nerdfonts
    ];

    fontconfig = {
      # Enable font antialiasing
      antialias = true;

      # Monospace font
      defaultFonts = {
        monospace = [
          "JetBrainsMono Nerd Font"
        ];

        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };


  #               #
  ## ENVIRONMENT ##
  #               #

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome-randr
    gnome-extension-manager
    gnomeExtensions.caffeine
    neofetch
    papirus-icon-theme
    paperview
    spicetify-cli
    swww
  ];
}
