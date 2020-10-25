{ config, pkgs, ... }:

{
  #               #
  ## ENVIRONMENT ##
  #               #

  # Install and configure Java
  programs.java.enable = true;

  environment = {
    # Set environment variables
    variables = {
      NEVERLANG_HOME = "$HOME/.local/lib/neverlang2-1.2";
      PATH = "$NEVERLANG_HOME/bin:$JAVA_HOME/bin:$HOME/.local/bin:$PATH";
    };

    # Packages installed in system profile
    systemPackages = with pkgs; [
      scala
      gnumake
      git
      subversion
    ];
  };
}
