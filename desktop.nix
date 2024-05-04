{ lib
, pkgset
, system
, home-manager
, ...
} @ inputs:

let
  inherit (pkgset) pkgsUnstable;
in
{
  modules = [
    ./modules/core.nix
    ./modules/desktop.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.baptiste = import ./modules/home.nix;
    }
  ];
  pkgs = pkgset.pkgs;
  specialArgs = { inherit pkgsUnstable; };
  system = system;
}
