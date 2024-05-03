{ lib, pkgs, config, ...}: 

{
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" "amdgpu" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/6dd5a283-7674-4424-aa81-fac1f6592f50";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-4c49385d-7760-4701-9e29-c8ab1ac7ed03".device = "/dev/disk/by-uuid/4c49385d-7760-4701-9e29-c8ab1ac7ed03";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2BFD-DF24";
      fsType = "vfat";
    };
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
