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
      home-manager.extraSpecialArgs = { inherit monitors hyprpaperConf; };
    }
  ];
  pkgs = pkgset.pkgs;
  specialArgs = { inherit pkgsUnstable; };
  system = system;
}
