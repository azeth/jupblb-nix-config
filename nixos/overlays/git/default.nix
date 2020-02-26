{ diff-so-fancy, git, makeWrapper, symlinkJoin, vim' }:

symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "git";
  paths       = [ git ];
  postBuild   = ''
    wrapProgram "$out/bin/git" \
      --add-flags "-c include.path=~/.config/git/gitconfig.local" \
      --add-flags "-c color.ui=true" \
      --add-flags "-c core.editor=${vim'}/bin/vim" \
      --add-flags "-c core.excludesfile=${./gitignore}" \
      --add-flags "-c core.mergeoptions=--no-edit" \
      --add-flags "-c diff.tool='${vim'}/bin/vim -d'" \
      --add-flags "-c difftool.prompt=false" \
      --add-flags "-c fetch.prune=true" \
      --add-flags "-c pager.diff='${diff-so-fancy}/bin/diff-so-fancy | less --tabs=1,5 -RFX'" \
      --add-flags "-c pager.show='${diff-so-fancy}/bin/diff-so-fancy | less --tabs=1,5 -RFX'" \
      --add-flags "-c push.default=upstream" 
  '';
}