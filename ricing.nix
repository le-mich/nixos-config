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

  services.gnome3 = {
    # Add Gnome Shell services
    core-shell.enable = true;
 
    # Enable Chrome Gnome Shell host connector to install extensions
    chrome-gnome-shell.enable = true;
  };

  # Qt like Gnome
  qt5.platformTheme = "gnome";


  #         #
  ## FONTS ##
  #         #

  fonts = {
    # Install fonts
    fonts = with pkgs; [
      iosevka
    ];

    fontconfig = {
      # Enable font antialiasing
      antialias = true;

      # Monospace font
      defaultFonts.monospace = [
        "iosevka"
      ];
    };
  };


  #               #
  ## ENVIRONMENT ##
  #               #

  environment.systemPackages = with pkgs; [
    neofetch
    zafiro-icons
    gnomeExtensions.gsconnect
    gnome3.gnome-tweaks
  ];
}
