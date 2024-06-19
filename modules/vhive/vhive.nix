{ config, lib, pkgs, inputs, ... }:
{
    imports = [
        ./firecracker-containerd.nix
    ];

    systemd.services.vhive = {
      wantedBy = [ "multi-user.target" ];
      after = [ "firecracker-containerd.service" "containerd.service" ];
      wants = [ "firecracker-containerd.service" "containerd.service" ];
      path = [
        pkgs.nettools
        pkgs.iptables
        pkgs.vhive
      ];
      serviceConfig.ExecStart = inputs.nur-niwa.packages.${pkgs.system}.vhive+"/bin/vhive";
    };
}
