{ pkgs, ... }:
{
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  services.blueman.enable = true;
}
