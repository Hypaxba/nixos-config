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
    nixpkgs-teleport15.url = "github:NixOS/nixpkgs/8d62b09309bee7d119508190e4f712041265a5d6";
  };

  outputs = { self, nixpkgs, nixpkgsUnstable, home-manager, nixpkgs-teleport15, ... } @ inputs:
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
        pkgsTeleport = pkgImport nixpkgs-teleport15 system;
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
