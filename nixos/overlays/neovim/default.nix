{ all-hies', bash-language-server, fetchFromGitHub, lib, makeWrapper, neovim, openjdk8, symlinkJoin, vimPlugins, vimUtils }:

let
  solarized8 = vimUtils.buildVimPluginFrom2Nix {
    pname   = "solarized8";
    version = "1.2.0";
    src     = fetchFromGitHub {
      owner  = "lifepillar";
      repo   = "vim-solarized8";
      rev    = "9afbe12f68082df4fab92d3cef3050910e7e9af2";
      sha256 = "1kb9ma1j0ijsvikzypc2dwdkrp5xy1cwcqs8gdz53n35kragfc9c";
    };
  };
  neovim' = neovim.override {
    configure   = {
      customRC = builtins.readFile(./init.vim);

      packages.myVimPackage = with vimPlugins; {
        opt   = [ ];
        start = [
          airline
          ctrlp
#         coc-json
#         coc-metals
          coc-nvim
#         coc-rust-analyzer
          easymotion
          fugitive
          gitgutter
          goyo
          solarized8
          surround
          vim-airline-themes
          vim-nix
          vim-startify
        ];
      };
    };

    vimAlias = true;
  
    withNodeJs  = true;
    withPython  = false;
    withPython3 = false;
    withRuby    = false;
  };
in symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "nvim";
  paths       = [ neovim' ];
  postBuild   = ''
    wrapProgram "$out/bin/nvim" --prefix PATH : ${lib.makeBinPath [ all-hies' bash-language-server openjdk8 ]}

    ln -sfn $out/bin/nvim $out/bin/vim
  '';
}
