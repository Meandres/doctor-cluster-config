# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  networking.hostId = "8425e348";

  fileSystems."/boot" = {
    device = "/dev/sda1";
    fsType = "vfat";
    options = ["nofail"];
  };

  fileSystems."/" = {
    device = "zroot/root/nixos";
    fsType = "zfs";
  };

  fileSystems."/tmp" = {
    device = "zroot/root/tmp";
    fsType = "zfs";
  };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 16;
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}