{ config, lib, pkgs, ... }:

{
  boot = {
    supportedFilesystems            = [ "zfs" ];
    initrd.availableKernelModules   = [
      "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"
    ];
    initrd.kernelModules            = [ "amdgpu" ];
    kernelPackages                  = pkgs.linuxPackages_latest;
    kernelParams                    = [ "mitigations=off" ];
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable      = true;
  };

  containers.azeth = {
    additionalCapabilities = [ "CAP_SYS_ADMIN" "CAP_SYS_RAWIO" ];
    allowedDevices         = [
      { modifier = "mrw"; node = "/dev/sda"; }
      { modifier = "mrw"; node = "/dev/sda1"; }
      { modifier = "mrw"; node = "/dev/zfs"; }
      { modifier = "mrw"; node = "/proc/self/mounts"; }
    ];
    autoStart              = true;
    bindMounts             = {
      "/dev/sda"          = { mountPoint = "/dev/sda"; isReadOnly = false; };
      "/dev/sda1"         = { mountPoint = "/dev/sda1"; isReadOnly = false; };
      "/dev/zfs"          = { mountPoint = "/dev/zfs"; isReadOnly = false; };
      "/proc/self/mounts" = { mountPoint = "/proc/self/mounts"; isReadOnly = false; };
    };
    config                 = {
      boot.supportedFilesystems  = [ "zfs" ];
      environment.systemPackages = with pkgs; [ file gptfdisk htop ];
#     fileSystems."/epool" =
#       { device = "epool";
#         fsType = "zfs";
#       };
      networking                 = {
        hostId   = "1366515e";
        hostName = "azeth";
      };
      programs                   = {
        bash.enableCompletion = true;
        bash.enableLsColors   = true;
        bash.promptInit       = builtins.readFile ./config/bashrc;
        vim.defaultEditor     = true;
      };
      services.openssh           = {
        openFirewall           = true;
        enable                 = true;
        passwordAuthentication = false;
        permitRootLogin        = "yes";
        ports                  = [ 1997 ];
      };
      users.users.azeth          = {
        extraGroups                 = [ "wheel" ];
        initialPassword             = "changeme";
        isNormalUser                = true;
        openssh.authorizedKeys.keys = [
          (builtins.readFile ./config/ssh/azeth/id_rsa.pub)
        ];
      };
    };
    enableTun                    = true;
    forwardPorts                 = [
       { containerPort = 1997; hostPort = 1997; protocol = "tcp"; }
       { containerPort = 1997; hostPort = 1997; protocol = "udp"; }
    ];
  };

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-uuid/9E04-A8F9";
    "/boot".fsType = "vfat";
  };

  fonts.enableDefaultFonts = true;
  fonts.fonts              = with pkgs; [
    emacs-all-the-icons-fonts vistafonts
  ];

  hardware = {
    bluetooth.enable = true;

    cpu.intel.updateMicrocode = true;

    opengl = {
      driSupport      = true;
      enable          = true;
      extraPackages   = with pkgs; [ amdvlk libvdpau-va-gl vaapiVdpau ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };

    pulseaudio = {
      enable       = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package      = pkgs.pulseaudioFull;
    };
  };

  home-manager.users.jupblb = {
    home.stateVersion = "20.03";

    programs = {
      firefox        = {
        enableGnomeExtensions         = true;
        profiles."jupblb".extraConfig = ''
          user_pref("widget.wayland-dmabuf-vaapi.enabled", true);
          user_pref("gfx.webrender.enabled", true);
        '';
        package                       = pkgs.firefox-wayland;
      };

      kitty.settings = { hide_window_decorations = "yes"; };
    };

    services.dropbox.enable = true;
  };

  imports = [ ./common/nixos.nix ];

  networking.hostId                = "5f500dcd";
  networking.hostName              = "hades";
  networking.networkmanager.enable = true;

  programs.steam.enable = true;

  services = {
    gnome3 = {
      chrome-gnome-shell.enable    = true;
      core-utilities.enable        = false;
      gnome-online-accounts.enable = true;
      gnome-settings-daemon.enable = true;
      sushi.enable                 = true;
    };

    gvfs.enable = true;

    printing = {
      drivers = with pkgs; [ samsung-unified-linux-driver_1_00_37 ];
      enable  = true;
    };

    syncthing = {
      configDir           = "/home/jupblb/.config/syncthing";
      dataDir             = "/home/jupblb/.local/share/syncthing";
      declarative = {
        cert    = toString ./config/syncthing/hades/cert.pem;
        folders = {
          "jupblb/Documents".path = "/home/jupblb/Documents";
          "jupblb/Pictures".path  = "/home/jupblb/Pictures";
        };
        key     = toString ./config/syncthing/hades/key.pem;
      };
      user                = "jupblb";
    };

    wakeonlan.interfaces = [ {
      interface = "eno2";
      method    = "magicpacket";
    } ];

    xserver = {
      enable                            = true;
      desktopManager.gnome3.enable      = true;
      desktopManager.gnome3.sessionPath = with pkgs.gnome3; [
        evince gnome-screenshot nautilus shotwell totem
      ];
      displayManager.autoLogin.enable   = true;
      displayManager.autoLogin.user     = "jupblb";
      displayManager.gdm.enable         = true;
      videoDrivers                      = [ "amdgpu" ];
    };
  };

  sound.enable = true;

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  system.stateVersion = "20.03";

  time.hardwareClockInLocalTime = true;

  users.users.jupblb.extraGroups = [ "lp" ];
}

