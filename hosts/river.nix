{
  imports = [
    ../modules/hardware/supermicro-x12spw-tf.nix
    ../modules/nfs/client.nix
    ../modules/dax.nix # just to disable PM as RAM
    ../modules/dpdk.nix
    ../modules/vfio/iommu-intel.nix
    ../modules/linux-ioregionfd.nix
  ];

  boot.hugepages1GB.number = 8;
  boot.hugepages2MB.number =
    let
      gb = 100;
    in
    gb * 1024 / 2;

  networking.hostName = "river";

  simd.arch = "icelake-server";

  system.stateVersion = "21.11";
}
