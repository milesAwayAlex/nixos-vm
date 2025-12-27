{
  pkgs,
  lib,
  var,
  ...
}:
{
  services.xserver = {
    enable = true;
    autoRepeatDelay = 150;
    autoRepeatInterval = 10;
    desktopManager.budgie.enable = true;
    displayManager.lightdm.enable = true;
    videoDrivers = [ "xql" ];
    xkb = {
      layout = "us";
      variant = "dvp";
    };
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = var.username;
  services.spice-autorandr.enable = true;
  services.spice-vdagentd.enable = true;

  systemd.user.services.spice-vdagent-client = {
    description = "spice vdagent client";
    enable = true;
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent -x";
      Restart = "on-failure";
      RestartSec = "5";
    };
  };

  environment.systemPackages = with pkgs; [
    blackbox-terminal
    spice
    spice-autorandr
    spice-vdagent
    x11spice
  ];

  environment.budgie.excludePackages = with pkgs.mate; [
    atril
    engrampa
    mate-calc
    pluma
  ];

  programs.dconf = {
    enable = true;
    profiles.user = {
      databases = [
        {
          lockAll = true; # prevents overriding
          settings = {
            # "org/gnome/desktop/background" = {
            #   color-shading-type = "solid";
            #   picture-options = "zoom";
            #   picture-uri = "file:///nix/store/zfij9q2dkd82d81r6gcizc1r5xa9v7h0-nineish-dark-gray-2020-07-02/share/backgrounds/nixos/nix-wallpaper-nineish-dark-gray.png";
            #   primary-color = "#151515";
            #   secondary-color = "#262626";
            # };
            # "org/gnome/desktop/interface" = {
            #   color-scheme = "prefer-dark";
            #   font-antialiasing = "rgba";
            #   scaling-factor = lib.gvariant.mkUint32 2;
            # };
            "org/gnome/desktop/input-sources" = {
              sources = [
                (lib.gvariant.mkTuple [
                  "xkb"
                  "us+dvp"
                ])
              ];
            };
            "org/gnome/settings-daemon/plugins/power" = {
              sleep-inactive-ac-type = "nothing";
            };
            "org/gnome/desktop/peripherals/keyboard" = {
              delay = lib.gvariant.mkUint32 150;
              repeat-interval = lib.gvariant.mkUint32 10;
            };
            "org/gnome/desktop/peripherals/mouse" = {
              accel-profile = "flat";
              natural-scroll = true;
              speed = 0.69;
            };
            "org/gnome/desktop/session" = {
              idle-delay = lib.gvariant.mkUint32 0;
            };
            "com/solus-project/budgie-panel" = {
              builtin-theme = true;
              dark-theme = true;
            };
            # "com/solus-project/budgie-panel/applets/{65e6a182-c06e-11f0-a174-5ebae9d6dc0f}" = {
            #   position = lib.gvariant.mkUint32 0;
            # };
            # "com/solus-project/budgie-panel/applets/{65e6cd2e-c06e-11f0-a174-5ebae9d6dc0f}" = {
            #   position = lib.gvariant.mkUint32 1;
            # };
            # "com/solus-project/budgie-panel/applets/{65e8af36-c06e-11f0-a174-5ebae9d6dc0f}" = {
            #   position = lib.gvariant.mkUint32 2;
            # };
            # "com/solus-project/clock/instance/clock/{c7e5b326-c435-11f0-be36-5ebae9d6dc0f}" = {
            #   custom-format = "%Z %H:%M:%S %m/%d";
            #   use-custom-format = true;
            # };
            # "com/solus-project/budgie-panel/applets/{c7e5b326-c435-11f0-be36-5ebae9d6dc0f}" = {
            #   position = lib.gvariant.mkUint32 3;
            #   alignment = "end";
            #   name = "Clock";
            # };
            # "com/solus-project/budgie-panel/applets/{4609e086-c438-11f0-be36-5ebae9d6dc0f}" = {
            #   alignment = "end";
            #   name = "User Indicator";
            #   position = lib.gvariant.mkUint32 4;
            # };
            # "com/solus-project/budgie-panel/applets/{65e9ff30-c06e-11f0-a174-5ebae9d6dc0f}" = {
            #   name = "Clock";
            #   position = lib.gvariant.mkUint32 5;
            # };
            # "com/solus-project/clock/instance/clock/{65e9ff30-c06e-11f0-a174-5ebae9d6dc0f}" = {
            #   custom-format = "%Z %H:%M %m/%d";
            #   custom-timezone = "America/Vancouver";
            #   use-custom-format = true;
            #   use-custom-timezone = true;
            # };
            # "com/solus-project/budgie-panel/applets/{65ea69b6-c06e-11f0-a174-5ebae9d6dc0f}" = {
            #   position = lib.gvariant.mkUint32 6;
            # };
            # "com/solus-project/budgie-panel/panels/{65da599a-c06e-11f0-a174-5ebae9d6dc0f}" = {
            #   applets = [
            #     "4609e086-c438-11f0-be36-5ebae9d6dc0f"
            #     "65da865e-c06e-11f0-a174-5ebae9d6dc0f"
            #     "65e57654-c06e-11f0-a174-5ebae9d6dc0f"
            #     "65e6a182-c06e-11f0-a174-5ebae9d6dc0f"
            #     "65e6cd2e-c06e-11f0-a174-5ebae9d6dc0f"
            #     "65e8af36-c06e-11f0-a174-5ebae9d6dc0f"
            #     "65e9ff30-c06e-11f0-a174-5ebae9d6dc0f"
            #     "65ea69b6-c06e-11f0-a174-5ebae9d6dc0f"
            #     "c7e5b326-c435-11f0-be36-5ebae9d6dc0f"
            #   ];
            #   autohide = "intelligent";
            #   dock-mode = true;
            # };
          };
        }
      ];
    };
  };
}
