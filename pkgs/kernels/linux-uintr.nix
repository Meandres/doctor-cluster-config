{ pkgs, lib, fetchFromGitHub, buildLinux, modDirVersionArg ? null, ... }@args:
buildLinux (args // rec {
    version = "6.6";
    modDirVersion = "6.6.0";
    # modDirVersion = "6.6.56";

    # src = pkgs.linuxPackages_6_6.kernel.src;
    src = fetchFromGitHub {
        owner = "Meandres";
        repo = "linux";
        rev = "7748b27fd6fb75621d7ff5e7ff5ec359f5a96613";
        sha256 = "sha256-dWiGPhRoYtesaun+umDd9OPg6vD2pV3quQv5vZQaJrQ=";
    };

    kernelPatches = [{
        name = "uintr-config";
        patch = null; #./uintr.patch;
        extraStructureConfig = {
            X86_X2APIC = lib.kernel.yes;
            X86_MCE = lib.kernel.yes;
            KVM = lib.kernel.yes;
            KVM_INTEL = lib.kernel.yes;
            X86_USER_INTERRUPTS = lib.kernel.yes;
            X86_UINTR_BLOCKING = lib.kernel.no;
        };
        # maybe enable X86_UINTR_BLOCKING later on
    }] ++ pkgs.linuxPackages_6_6.kernel.kernelPatches;
    extraMeta.branch = version;
    ignoreConfigErrors = true;
} // (args.argsOverride or { }))
