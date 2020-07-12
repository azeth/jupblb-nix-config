{
  autoreconfHook, callPackage, emacs, emacsPackages, fd, fetchFromGitHub, lib,
  makeWrapper, ripgrep, symlinkJoin, texinfo, wayland, wayland-protocols
}:

let doom-emacs = callPackage(builtins.fetchTarball {
  url = https://github.com/vlaci/nix-doom-emacs/archive/master.tar.gz;
}) {
  doomPrivateDir = ./.;
  emacsPackages  = emacsPackages.overrideScope' (self: super: {
    emacs = emacs.overrideAttrs(old: {
      buildInputs       = old.buildInputs ++ [ wayland wayland-protocols ];
      configureFlags    = old.configureFlags ++ [
        "--without-x" "--with-cairo" "--with-modules"
      ];
      nativeBuildInputs = old.nativeBuildInputs ++ [ autoreconfHook texinfo ];
      patches           = [];

      src = fetchFromGitHub {
        owner  = "masm11";
        repo   = "emacs";
        rev    = "pgtk";
        sha256 = "0wbjf88hyl6b1ikqh1rfgaib5y0v6py6k6s1bgi1sqq4zf5afgsv";
      };
    });
  });
};
in symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "emacs";
  paths       = doom-emacs;
  postBuild   = ''
    wrapProgram $out/bin/emacs \
      --prefix PATH : ${lib.makeBinPath[ fd ripgrep ]}
  '';
}
