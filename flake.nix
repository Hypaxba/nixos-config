{
  description = "NixOS configuration";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-25.05";
    };
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager?ref=release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-teleport12.url = "github:NixOS/nixpkgs/a0405f0aa64994236abdf558ba7739df9dbe2391";
  };

  outputs = { self, nixpkgs, nixpkgsUnstable, home-manager, nixpkgs-teleport12, ... } @ inputs:
    let
      system = "x86_64-linux";
      inherit (nixpkgs) lib;
      pkgImport = pkgs: system:
        import pkgs {
          inherit system;
          config.allowUnfree = true;
        };
      pkgset = {
        pkgs = pkgImport nixpkgs system;
        pkgsUnstable = pkgImport nixpkgsUnstable system;
        pkgsTeleport = pkgImport nixpkgs-teleport12 system;
      };
      inherit (pkgset) pkgs pkgsUnstable pkgsTeleport;
    in
    {
      nixosConfigurations = {
        desktop = lib.nixosSystem (import ./desktop.nix { inherit lib system pkgset home-manager; });
        laptop = lib.nixosSystem (import ./laptop.nix { inherit lib system pkgset home-manager; });
        work-laptop = lib.nixosSystem (import ./work-laptop.nix { inherit lib system pkgset home-manager; });
      };
      formatter.${system} = pkgs.nixpkgs-fmt;
    };

}
