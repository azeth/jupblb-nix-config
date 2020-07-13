{
  callPackage, emacs-nox, emacsPackages, fd, lib, makeWrapper, ripgrep,
  symlinkJoin
}:

let doom-emacs = callPackage(builtins.fetchTarball {
  url = https://github.com/vlaci/nix-doom-emacs/archive/master.tar.gz;
}) {
  doomPrivateDir = ./.;
  emacsPackages  = emacsPackages.overrideScope'(self: super: {
    emacs = emacs-nox;
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
