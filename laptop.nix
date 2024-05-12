{ lib
, pkgset
, system
, home-manager
, ...
} @ inputs:

let
  inherit (pkgset) pkgsUnstable;
  monitors = [
    "eDP-1, 2160x1440@60, 0x0, 1"
  ];
  hyprpaperConf = "laptop.";
  modLeft = [ ];
  modRight = [ "cpu" "memory" "backlight" "pulseaudio" "bluetooth" "network" "battery" ];
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
    "backlight" = {
      "device" = "intel_backlight";
      "format" = "<span color='#b4befe'>{icon}</span> {percent}%";
      "format-icons" = [ "" "" "" "" "" "" "" "" "" ];
      "tooltip" = false;
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
      "bluetooth" = {
        "format" = "<span color='#b4befe'></span> {status}";
        "format-disabled" = "";
        "format-connected" = "<span color='#b4befe'></span> {num_connections}";
        "tooltip-format" = "{device_enumerate}";
        "tooltip-format-enumerate-connected" = "{device_alias}   {device_address}";
      };
      "network" = {
        "interface" = "wlp0s20f3";
        "format" = "{ifname}";
        "format-wifi" = "<span color='#b4befe'> </span>{essid}";
        "format-ethernet" = "{ipaddr}/{cidr} 󰈀";
        "format-disconnected" = "<span color='#b4befe'>󰖪 </span>No Network";
        "tooltip" = false;
      };
      "battery" = {
        "format" = "<span color='#b4befe'>{icon}</span> {capacity}%";
        "format-icons" = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󱊣" ];
        "format-charging" = "<span color='#b4befe'>󰂄</span> {capacity}%";
        "tooltip" = false;
      };
    };
  };
in
{
  modules = [
    ./modules/core.nix
    ./modules/hardware-laptop.nix
    ./modules/laptop.nix
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
