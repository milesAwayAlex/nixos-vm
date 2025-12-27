{ pkgs, ... }:
{
  services.blocky = {
    enable = true;
    settings = {
      ports.dns = "53";

      upstreams.groups.default = [ "127.0.0.1:5353" ];

      blocking = {
        loading = {
          downloads = {
            attempts = 8;
            cooldown = "2s";
          };
          strategy = "fast";
          concurrency = 1;
        };
        denylists = {
          # ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
          pro = [ "https://codeberg.org/hagezi/mirror2/raw/branch/main/dns-blocklists/wildcard/pro.txt" ];
          tif = [ "https://codeberg.org/hagezi/mirror2/raw/branch/main/dns-blocklists/wildcard/tif.txt" ];
        };
        clientGroupsBlock.default = [
          "pro"
          "tif"
          # "ads"
        ];
      };

      caching = {
        prefetching = false;
      };
    };
  };

  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "127.0.0.1@5353" ];
        port = 5353;

        harden-dnssec-stripped = true;
        prefetch = true;

        verbosity = 3;

        private-address = [
          "10.0.0.0/8"
          "172.16.0.0/12"
          "192.168.0.0/16"
        ];
      };
    };
  };

  networking.nameservers = [ "127.0.0.1" ];

  systemd.services.blocky.after = [ "unbound.service" ];
  systemd.services.blocky.requires = [ "unbound.service" ];
}
