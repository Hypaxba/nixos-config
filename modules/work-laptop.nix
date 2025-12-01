{ pkgs, lib, pkgsTeleport, pkgsUnstable, ... }:
{

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.thermald.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
             "slack" "1password" "terraform" "pritunl-client" "vscode" "vault" "cursor"
         ];

  users.users.baptiste.packages = with pkgs; [
    bluez
    slack
    _1password-gui
    pritunl-client
    rancher
    vscode
    postgresql
    kubectx
    kubectl-view-secret
    pkgsTeleport.teleport_15
    azure-cli
    terraform
    kind
    k9s
    jq
    vault
    fzf
    uv
    python314
    devenv
    kubernetes-helm
    krew
    go-swagger
    kubectl-node-shell
    pkgsUnstable.code-cursor
    argo-workflows
    azure-storage-azcopy
    gh
    kubectx
    kns
    yq
  ];
  
  systemd = { packages = [ pkgs.pritunl-client ]; targets = { multi-user = { wants = [ "pritunl-client.service" ]; }; }; }; 


  xdg = {
  portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };
};

  programs.xwayland.enable = true;

  system.stateVersion = lib.mkForce "25.05";

  networking.networkmanager.enable = true;

}
