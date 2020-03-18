{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  boot.extraModprobeConfig           = "options snd_hda_intel power_save=1";
  boot.initrd.availableKernelModules = [
    "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "ums_realtek" "sd_mod" "sr_mod"
  ];

  environment.systemPackages = with pkgs.unstable; [ ferdi' sway' xwayland ];

  fileSystems."/".device     = "/dev/disk/by-label/nixos";
  fileSystems."/".fsType     = "xfs";
  fileSystems."/boot".device = "/dev/disk/by-label/boot";
  fileSystems."/boot".fsType = "vfat";

  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel' vaapiVdpau libvdpau-va-gl intel-media-driver ];

  networking.hostName = "ares";

  nix.maxJobs = 8;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="d8:50:e6:03:5c:44", NAME="eth"
    ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="70:18:8b:3f:58:47", NAME="wlp"
  '';

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  system.stateVersion = "19.09";
}