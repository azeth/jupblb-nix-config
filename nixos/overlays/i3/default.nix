{
  bemenu, dunst, firefox, ferdi', gnome-screenshot,
  i3-gaps, i3status', idea-ultimate', imv, lib,
  makeWrapper, mpv, pavucontrol, qutebrowser, redshift,
  symlinkJoin, writeTextFile, zoom-us
}:

let
  i3Config = writeTextFile {
    name = "config";
    text = ''
      exec --no-startup-id ${dunst}/bin/dunst -conf ${./dunstrc}
      exec --no-startup-id ${redshift}/bin/redshift -l 51.12:17.05
      set $browser env QT_SCALE_FACTOR=2 ${qutebrowser}/bin/qutebrowser --basedir ~/.local/share/qutebrowserx
      set $menu ${bemenu}/bin/bemenu-run \
        --fn 'PragmataPro 26' -p "" --fb '#eee8d5' --ff '#073642' --hb '#98971a' --hf '#073642' --nb '#eee8d5' --nf '#073642' \
        --sf '#eee8d5' --sb '#073642' --tf '#073642' --tb '#eee8d5' | xargs swaymsg exec --
      set $print ${gnome-screenshot}/bin/gnome-screenshot -i --display=:0
      ${builtins.readFile(../common-wm-config)}
      ${builtins.readFile(./i3-config)}
    '';
  };
in symlinkJoin {
  name        = "i3";
  buildInputs = [ makeWrapper ];
  paths       = [ i3-gaps ];
  postBuild   = ''
    wrapProgram "$out/bin/i3" \
      --add-flags "-c ${i3Config}" \
      --prefix PATH : ${lib.makeBinPath [ firefox ferdi' i3status' idea-ultimate' imv mpv pavucontrol zoom-us ]}
  '';
}
