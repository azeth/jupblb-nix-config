{
  bemenu, callPackage, grim, imv, lib, makeWrapper, mpv, pavucontrol,
  redshift-wlr, slurp, sway, swaylock, symlinkJoin, wayvnc, wdisplays,
  wl-clipboard, wob, writeTextFile, xdg-user-dirs, xsettingsd
}:

let
  path   = lib.makeBinPath [
    imv mpv pavucontrol wdisplays wl-clipboard (callPackage ./xwayland.nix {})
  ];
  config = {
    common   = callPackage ./sway-config.nix {};
    headless = writeTextFile {
      name = "sway-config-headless";
      text = ''
        ${config.common}
        exec ${wayvnc}/bin/wayvnc --keyboard=pl
        seat seat0 keyboard_grouping none
      '';
    };
    regular  = writeTextFile {
      name = "sway-config";
      text = ''
        ${config.common}
        exec --no-startup-id ${redshift-wlr}/bin/redshift \
          -m wayland -l 51.12:17.05
        bindsym $mod+BackSpace exec ${swaylock}/bin/swaylock
      '';
    };
  };
  sway'  = sway.override {
    extraSessionCommands = builtins.readFile ./sway.sh;
    sway-unwrapped       = callPackage ./sway-unwrapped.nix {};
    withGtkWrapper       = true;
  };
in symlinkJoin {
  name        = "sway";
  buildInputs = [ makeWrapper ];
  paths       = [ sway' ];
  postBuild   = ''
    mv $out/bin/sway $out/bin/sway-clean

    makeWrapper "$out/bin/sway-clean" $out/bin/sway \
      --add-flags "-c ${config.regular}" \
      --prefix PATH : ${path}

    makeWrapper "$out/bin/sway-clean" $out/bin/sway-headless \
      --add-flags "-c ${config.headless}" \
      --prefix PATH : ${path} \
      --set WLR_BACKENDS "headless" \
      --set WLR_LIBINPUT_NO_DEVICES 1
  '';
}