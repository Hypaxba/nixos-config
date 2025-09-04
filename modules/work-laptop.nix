{ pkgs, lib, ... }:
{
  services.blueman.enable = true;

  services.thermald.enable = true;

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
    teleport
    azure-cli
    terraform
  ];
  
  systemd = { packages = [ pkgs.pritunl-client ]; targets = { multi-user = { wants = [ "pritunl-client.service" ]; }; }; }; 
  
  

  system.stateVersion = lib.mkForce "25.05";

  networking.networkmanager.enable = true;

}
