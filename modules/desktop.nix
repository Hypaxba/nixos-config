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

  networking.interfaces."enp6s0".useDHCP = true;

  #vm bridge
  #networking.bridges = {
  #   br0 = {
  #       interfaces = [
  #         "enp6s0"
  #       ];
  #  };
  #};
  #networking.interfaces.br0.useDHCP = true;

}
