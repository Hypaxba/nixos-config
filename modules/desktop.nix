{ pkgs, ... }:

{
  programs.steam.enable = true;

  users.users.baptiste.packages = with pkgs; [
    protontricks
    steamtinkerlaunch
    gamescope
    mixxx
  ];
}
