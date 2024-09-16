{ pkgs, ... }:

{

  users.users.baptiste.packages = with pkgs; [
    protontricks
    steamtinkerlaunch
    gamescope
    mixxx
  ];
}
