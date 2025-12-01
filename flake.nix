{
  description = "WIP NixOS VM";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators }: {
    nixosModules.active = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        # e2fsprogs
        # gnome-monitor-config
        # virglrenderer
        dig
        tmux
        vim
      ];

      users.users.frozen = {
        description = "Regular User";
        extraGroups = [ "networkmanager" "wheel" ];
        isNormalUser = true;

        packages = with pkgs; [
          # ungoogled-chromium
          chromium
          deluge
          telegram-desktop
        ];
      };

      fileSystems."/home" = {
         device = "/dev/vdb";
         fsType = "ext4";
      };

      programs.captive-browser = {
        enable = true;
        interface = "enp0s1";
      };

      # programs.chromium = {
      #   enable = true;
      #   extraOpts = {
      #     BuiltInDnsClientEnabled = false;
      #     DnsOverHttpsMode = 0;
      #   };
      # };

      # WebDAV file sharing
      services.spice-webdavd.enable = true;
      services.davfs2 = {
        enable = true;
        settings = {
          globalSection = {
            ask_auth = 0;
          };
        };
      };
      fileSystems."/mnt/vm-share" = {
        device = "http://127.0.0.1:9843/";
        fsType = "davfs";
        options = [ "nofail" ];
      };
    };
    nixosModules.base = {pkgs, ...}: {
      security.sudo.wheelNeedsPassword = false;
      services.qemuGuest.enable = true;

      # shaves about 700MB off the image size
      nix.enable = false;
      documentation = {
        enable = false;
        man.enable = false;
        info.enable = false;
      };

      # nixpkgs.config.allowUnfree = true;

      system.stateVersion = "25.05";
    };
    nixosModules.budgie = ./budgie.nix;
    nixosModules.resolver = ./resolver.nix;
    nixosModules.vm = {pkgs, ...}: {
      virtualisation.vmVariant.virtualisation.diskImage = null;
      virtualisation.vmVariant.virtualisation.host.pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      virtualisation.vmVariant.virtualisation.memorySize = 4096;
      virtualisation.vmVariant.virtualisation.cores = 8;
      virtualisation.vmVariant.virtualisation.qemu.guestAgent.enable = true;
    };
    nixosConfigurations.darwinVM = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = with self.nixosModules; [
        active
        base
        vm
      ];
    };
    packages.aarch64-darwin.darwinVM = self.nixosConfigurations.darwinVM.config.system.build.vm;
    packages.aarch64-darwin.qcow = nixos-generators.nixosGenerate {
      format = "qcow";
      system = "aarch64-linux";
      modules = with self.nixosModules; [
        active
        base
        budgie
        resolver
      ];
    };
  };
}
