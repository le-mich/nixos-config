{ config, pkgs, ... }:

{
  #              #
  ## BOOTLOADER ##
  #              #

  # Plymouth splash screen with default values
  boot.plymouth.enable = true;


  #           #
  ## LIGHTDM ##
  #           #

  # Set mini-greeter for lightdm
  #services.xserver.displayManager.lightdm.greeters.mini = {
  #  enable = true;
  #  user = "mich";
  #  extraConfig = ''
  #    [greeter]
  #    show-password-label = false
  #    [greeter-theme]
  #    background-image = ""
  #  '';
  #};


  #         #
  ## GNOME ##
  #         #

  services.gnome3 = {
    # Add Gnome Shell services
    core-shell.enable = true;
 
    # Enable Chrome Gnome Shell host connector to install extensions
    chrome-gnome-shell.enable = true;
  };


  #         #
  ## FONTS ##
  #         #

  fonts = {
    # Install fonts
    fonts = with pkgs; [
      mononoki
      fira-code-symbols
    ];

    fontconfig = {
      # Enable font antialiasing
      antialias = true;

      # Monospace font
      defaultFonts.monospace = [
        "mononoki"
        "fira-code"
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
