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
      home-manager.extraSpecialArgs = { inherit monitors; };
    }
  ];
  pkgs = pkgset.pkgs;
  specialArgs = { inherit pkgsUnstable; };
  system = system;
}
