{ lib
, pkgset
, system
, home-manager
, ...
} @ inputs:

{
   modules = [
     ./modules/core.nix
     ./modules/desktop.nix
     home-manager.nixosModules.home-manager {
       home-manager.useGlobalPkgs = true;
       home-manager.useUserPackages = true;
       home-manager.users.baptiste = import ./modules/home.nix;
     }
   ];
   pkgs = pkgset.pkgs;
   system = system;
}
