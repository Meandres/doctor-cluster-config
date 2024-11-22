{
  modulesPath,
  lib,
  pkgs,
  config,
  ...
}:

# To deploy as a systemd-nspawn container on a new host:
# $ nix run github:nix-community/nixos-generators -- --format lxc --flake '.#doctor'
# $ cat /etc/systemd/nspawn/doctor.nspawn
# [Exec]
# Capability = all
# PrivateUsers = no
#
# [Network]
# VirtualEthernet = no
# $ mkdir -p /var/lib/machines/doctor
# $ tar -C /var/lib/machines/doctor -xvf nixos-system-x86_64-linux.tar.xz
# # boot like this:
# $ systemd-nspawn --capability=CAP_NET_ADMIN -D /var/lib/machines/doctor -b
# # or this:
# $ machinectl start doctor

{
  imports = [
    (modulesPath + "/virtualisation/lxc-container.nix")
    ../modules/borgbackup-repos
    ../modules/buildbot/reverse-proxy.nix
    ../modules/monitoring/prometheus
    ../modules/monitoring/loki.nix
    ../modules/monitoring/telegraf.nix
  ];

  simd.arch = "broadwell";

  # This also adds `/etc/os-release` to the lxc tarball
  system.build.tarball = lib.mkForce (
    pkgs.callPackage (pkgs.path + "/nixos/lib/make-system-tarball.nix") {
      extraArgs = "--owner=0";

      storeContents = [
        {
          object = config.system.build.toplevel;
          symlink = "none";
        }
      ];

      contents = [
        {
          source = config.system.build.toplevel + "/init";
          target = "/sbin/init";
        }
        {
          source = config.system.build.toplevel + "/etc/os-release";
          target = "/etc/os-release";
        }
      ];

      extraCommands = "mkdir -p proc sys dev";
    }
  );

  services.openssh.extraConfig = ''
    ListenAddress [42:0:3c46:96e2:72f4:be89:d6eb:ab14]
  '';
  services.openssh.startWhenNeeded = false;

  # our container profile seems to set this, but it is broken.
  environment.noXlibs = false;

  networking.hostName = "doctor";

  # let the host manage these
  systemd.network.networks."ethernet".extraConfig = ''
    [Match]
    Type = ether

    [Link]
    Unmanaged = yes
  '';

  services.resolved.enable = false;

  # TODO
  #simd.arch = "cascadelake";

  system.stateVersion = "21.11";
}
