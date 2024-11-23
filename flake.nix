{
  description = "NixOS configuration";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-24.11";
    };
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager?ref=release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgsUnstable, home-manager, ... } @ inputs:
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
      };
      inherit (pkgset) pkgs pkgsUnstable;
    in
    {
      nixosConfigurations = {
        desktop = lib.nixosSystem (import ./desktop.nix { inherit lib system pkgset home-manager; });
        laptop = lib.nixosSystem (import ./laptop.nix { inherit lib system pkgset home-manager; });
      };
      formatter.${system} = pkgs.nixpkgs-fmt;
    };

}
