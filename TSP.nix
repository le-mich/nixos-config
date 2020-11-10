{ config, pkgs, ... }:

{
  #               #
  ## ENVIRONMENT ##
  #               #

  environment = {
    # Set environment variables
    variables = {
      NEVERLANG_HOME = "$HOME/.local/lib/neverlang2-1.2";
      PATH = "$NEVERLANG_HOME/bin:$JAVA_HOME/bin:$HOME/.local/bin:$PATH";
    };

    # Packages installed in system profile
    systemPackages = with pkgs; [
      teams
      zeal
      openjdk14
      scala
      gnumake
      git
      subversion
    ];
  };
}
