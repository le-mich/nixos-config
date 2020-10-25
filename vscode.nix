{ config, pkgs, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    { config = config.nixpkgs.config; };
in
{
  # Use nixos-unstable repo to install VSCode because the nixos-20.03 version is old
  environment.systemPackages = with pkgs; [
    unstable.vscode
  ];
}
