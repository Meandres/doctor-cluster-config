{ config, lib, pkgs, inputs, ... }:
{
systemd.services.firecracker-containerd = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [
        pkgs.bc
        pkgs.util-linux
        pkgs.firecracker
        inputs.nur-niwa.packages.${pkgs.system}.firecracker-containerd
        pkgs.lvm2
        pkgs.e2fsprogs
        pkgs.pigz
        # for runc
        pkgs.containerd
        pkgs.runc
      ];
      serviceConfig.ExecStart = inputs.nur-niwa.packages.${pkgs.system}.firecracker-containerd+"/bin/containerd";
    };
}
