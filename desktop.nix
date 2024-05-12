{ lib
, pkgset
, system
, home-manager
, ...
} @ inputs:

let
  inherit (pkgset) pkgsUnstable;
  monitors = [
    "HDMI-A-1, 1920x1080@60, 0x0, 1"
    "DP-1, 2560x1080@60, 1920x0, 1"
  ];
  hyprpaperConf = "";
  modWaybar = {
    "hyprland/workspaces" = {
      "format" = "{icon}";
      "all-outputs" = true;
      "format-icons" = {
        "1" = "1";
        "2" = "2";
        "3" = "3";
        "4" = "4";
        "5" = "5";
        "6" = "6";
        "7" = "7";
        "8" = "8";
        "9" = "9";
        "10" = "10";
      };
    };

    "clock" = {
      "format" = "<span color='#b4befe'> </span>{:%H:%M}";
      "tooltip" = true;
      "tooltip-format" = "{:%Y-%m-%d %a}";
    };

    "cpu" = { "format" = "<span color='#b4befe'> </span>{usage}%"; };
    "memory" = {
      "interval" = 1;
      "format" = "<span color='#b4befe'> </span>{used:0.1f}G/{total:0.1f}G";
    };
    "pulseaudio" = {
      "format" = "<span color='#b4befe'>{icon}</span> {volume}%";
      "format-muted" = "";
      "tooltip" = false;
      "format-icons" = {
        "headphone" = "";
        "default" = [ "" "" "󰕾" "󰕾" "󰕾" "" "" "" ];
      };
      "scroll-step" = 1;
      "on-click" = "pavucontrol";
    };

  };
  modLeft = [ ];
  modRight = [ "backlight" "bluetooth" "network" "battery" ];
in
{
  modules = [
    ./modules/core.nix
    ./modules/hardware-desktop.nix
    ./modules/desktop.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.baptiste = import ./modules/home.nix;
      home-manager.extraSpecialArgs = { inherit monitors hyprpaperConf modLeft modRight modWaybar; };
    }
  ];
  pkgs = pkgset.pkgs;
  specialArgs = { inherit pkgsUnstable; };
  system = system;
}
