{ pkgs, pkgsUnstable, ... }:

{

  users.users.baptiste.packages = with pkgs; [
    protontricks
    steamtinkerlaunch
    gamescope
    mixxx
    prismlauncher
    atlauncher
    jdk17
    pkgsUnstable.nexusmods-app
  ];

  hardware.xone.enable = true;
}
