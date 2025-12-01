{ pkgs, pkgsUnstable, ... }:

{

  users.users.baptiste.packages = with pkgs; [
    protontricks
    steamtinkerlaunch
    gamescope
    mixxx
    prismlauncher
    pkgsUnstable.atlauncher
    jdk17
    pkgsUnstable.nexusmods-app
  ];

  hardware.xone.enable = true;

  networking.interfaces."enp6s0".useDHCP = true;

  services.dnsmasq = {
    enable = true;
    settings.server = ["/test/10.243.117.7"];
  };

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
