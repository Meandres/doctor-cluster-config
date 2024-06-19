{ inputs, pkgs, ... }:
{
  imports = [
    ../modules/ipmi-supermicro.nix
    ../modules/hardware/supermicro-AS-2015CS.nix
    ../modules/nfs/client.nix
    ../modules/vfio/iommu-amd.nix
    ../modules/dpdk.nix
    ../modules/vhive/vhive.nix
  ];

  # General
  networking.hostName = "irene";
  # Use the Samsung SSD for the system
  disko.rootDisk = "/dev/disk/by-id/nvme-SAMSUNG_MZQL23T8HCLS-00A07_S64HNE0T804198";
  system.stateVersion = "22.11";
  simd.arch = "znver4";

  # udos related stuff
  # Use the PCI 5.0 SSD for the experiments. This lines binds it automatically to vfio
  #virtualisation.vfio.devices = [ "1e0f:0013" ]; 
  boot.kernel.sysctl = { "vm.overcommit_memory" = 1; };

  # ukbpf related stuff
  /*virtualisation.containerd = {
    enable = true;
    settings = {
        version = 2;
        plugins."io.containerd.grpc.v1.cri".containerd = {
            runtimes.runc = {
                runtime_type = "io.containerd.runc.v2";
                options = {
                    SystemdCgroup = true;
                    BinaryName = pkgs.runc;
                };
            };
            runtimes.urunc = {
                runtime_type = "io.containerd.urunc.v2";
                container_annotations = ["com.urunc.unikernel.*"];
                pod_annotations = ["com.urunc.unikernel.*"];
                options = {
                    #SystemdCgroup = true;
                    BinaryName = inputs.nur-niwa.packages.${pkgs.system}.urunc+"/bin/urunc";
                };
            };
        };
    };
  };
  systemd.services.containerd.path = [ pkgs.containerd inputs.nur-niwa.packages.${pkgs.system}.urunc pkgs.runc pkgs.cni pkgs.cni-plugins pkgs.iptables pkgs.qemu_full ];

  systemd.services.buildkitd = {
    enable = true;
    path = [ pkgs.buildkit pkgs.runc ];
    after = [ "containerd.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.buildkit}/bin/buildkitd";
    };
  };*/
  environment.systemPackages = [
    #pkgs.iptables
    #pkgs.nerdctl
    #pkgs.qemu_full
    #inputs.nur-niwa.packages.${pkgs.system}.bima
    #inputs.nur-niwa.packages.${pkgs.system}.urunc
    #pkgs.buildkit
    inputs.nur-niwa.packages.${pkgs.system}.vhive
  ];

}
