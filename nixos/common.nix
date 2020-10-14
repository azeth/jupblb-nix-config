{ config, lib, pkgs, ... }:

{
  boot = {
    kernelParams         = [ "mitigations=off" ];
    loader.timeout       = 3;
    supportedFilesystems = [ "ntfs" "exfat" ];
    tmpOnTmpfs           = true;
  };

  console = {
    colors     = [
      "f9f5d7" "cc241d" "98971a" "d79921"
      "458588" "b16286" "689d6a" "7c6f64"
      "928374" "9d0006" "79740e" "b57614"
      "076678" "8f3f71" "427b58" "3c3836"
    ];
    earlySetup = true;
    font       = "ter-232n";
    keyMap     = "pl";
    packages   = [ pkgs.terminus_font ];
  };

  environment.systemPackages = with pkgs; [ file git htop patchelf unzip ];

  hardware.enableRedistributableFirmware = true;

  i18n.defaultLocale    = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "pl_PL.UTF-8/UTF-8" ];

  networking.useDHCP = false;

  nixpkgs.config.allowUnfree = true;

  programs = {
    bash.enableCompletion = true;
    bash.enableLsColors   = true;
    bash.promptInit       = builtins.readFile ./misc/bashrc;
    ssh.extraConfig       = builtins.readFile ./misc/ssh-config;
    vim.defaultEditor     = true;
  };

  services = {
    acpid.enable = true;

    mingetty.autologinUser = "jupblb";

    openssh = {
      openFirewall           = true;
      enable                 = true;
      passwordAuthentication = false;
      permitRootLogin        = "no";
      ports                  = [ 22 1993 ];
    };

    printing = {
      drivers = with pkgs; [ samsung-unified-linux-driver_1_00_37 ];
      enable  = true;
    };

    sshguard.enable = true;
  };

  system.activationScripts.bin-bash = lib.stringAfter [ "usrbinenv" ] ''
    ln -sfn ${pkgs.bashInteractive}/bin/bash /bin/bash
  '';

  time.timeZone = "Europe/Warsaw";

  users.users.jupblb = {
    description                 = "Michal Kielbowicz";
    extraGroups                 = [ "lp" "networkmanager" "wheel" ];
    initialPassword             = "changeme";
    isNormalUser                = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEtq1CzRgt2HFdkUL7kCx+4r63J9m36CVBtTmIIC4BvN ssh@kielbowi.cz"
    ];
    shell                       = pkgs.fish;
  };
}
