{ config, lib, pkgs, ... }:

{
  home.packages         = with pkgs; [ gitAndTools.git-crypt ripgrep ];
  home.sessionVariables = {
    DOOMDIR      = ../config/doom;
    DOOMLOCALDIR = "~/.local/share/doom";
    EDITOR       = "nvim";
  };
  home.username         = "jupblb";

  nixpkgs.overlays = [
    (import ./overlay)
    (self: super: { fish-foreign-env = pkgs.fishPlugins.foreign-env; })
  ];

  programs = {
    bat = {
      config = { theme = "gruvbox-light"; };
      enable = true;
    };

    emacs = {
      enable        = true;
      extraPackages = epkgs: with epkgs; [ langtool vterm ];
      package       = pkgs.emacs-wrapped;
    };

    fish = {
      enable               = true;
      interactiveShellInit = "theme_gruvbox light hard";
      plugins              = lib.mapAttrsToList
        (name: pkg: { name = name; src = pkg; }) pkgs.fishPlugins;
      promptInit           = builtins.readFile ../config/prompt.fish;
      shellAliases         = {
        cat  = "bat -p --paging=never";
        doom = "~/.config/emacs/bin/doom";
        less = "bat -p --paging=always";
        ls   = "${pkgs.exa}/bin/exa";
      };
    };

    fzf = {
      enable         = true;
      defaultOptions = [ "--color=light" ];
    };

    git = {
      delta       = {
        enable  = true;
        options = {
          line-numbers            = true;
          line-numbers-zero-style = "#3c3836";
          minus-emph-style        = "syntax #fa9f86";
          minus-style             = "syntax #f9d8bc";
          plus-emph-style         = "syntax #d9d87f";
          plus-style              = "syntax #eeebba";
          side-by-side            = true;
          syntax-theme            = "gruvbox-light";
        };
      };
      enable      = true;
      extraConfig = {
        color.ui          = true;
        core.mergeoptions = "--no-edit";
        fetch.prune       = true;
        pull.rebase       = true;
        push.default      = "upstream";
      };
      signing     = { key = "1F516D495D5D8D5B"; signByDefault = true; };
      userEmail   = "mpkielbowicz@gmail.com";
      userName    = "jupblb";
    };

    gpg.enable = true;

    htop = {
      colorScheme         = 3;
      enable              = true;
      hideThreads         = true;
      hideUserlandThreads = true;
      showCpuFrequency    = true;
    };

    kitty = {
      enable   = true;
      font     = {
        package = pkgs.pragmata-pro;
        name    = "PragmataPro Mono Liga";
      };
      settings = {
        background        = "#f9f5d7";
        clipboard_control = "write-clipboard write-primary no-append";
        font_size         = 10;
        foreground        = "#282828";
        startup_session   = toString(pkgs.writeText "kitty-launch" ''
          launch ${pkgs.fish}/bin/fish -c "${pkgs.tmux}/bin/tmux; and exit"
        '');
      };
    };

    lf = {
      enable      = true;
      extraConfig = builtins.readFile ../config/lfrc.sh;
      previewer   = {
        keybinding = "i";
        source     = with pkgs; writeShellScript "lf-preview" ''
          case "$1" in
            *.json)       ${jq}/bin/jq --color-output . "$1";;
            *.md)         ${glow}/bin/glow -s light - "$1";;
            *.pdf)        ${poppler_utils}/bin/pdftotext "$1" -;;
            *.tar*|*.zip) ${atool}/bin/atool --list -- "$1";;
            *)            ${bat}/bin/bat --style=numbers --color always "$1";;
          esac
        '';
      };
      settings    = { hidden = true; tabstop = 4; };
    };

    mercurial = {
      enable      = true;
      extraConfig = { pager.pager = "${pkgs.gitAndTools.delta}/bin/delta"; };
      userEmail   = "mpkielbowicz@gmail.com";
      userName    = "jupblb";
    };

    neovim = {
      extraConfig   = builtins.readFile ../config/neovim/init.vim;
      plugins       = with pkgs.vimPlugins; [ {
          plugin = lightline-vim;
          config = ''
            set noshowmode
            let g:lightline = { 'colorscheme': 'gruvbox' }
          '';
        } {
          plugin = glow-nvim;
          config = "let $GLOW_STYLE = 'light' | nmap <Leader>m :Glow<CR>";
        } {
          plugin = gruvbox-community;
          config = builtins.readFile ../config/neovim/gruvbox-community.vim;
        } {
          plugin = fzf-vim;
          config = builtins.readFile ../config/neovim/fzf.vim;
        } {
          plugin = lf-vim;
          config = builtins.readFile ../config/neovim/lf.vim;
        } {
          plugin = nvim-lspconfig;
          config = ''
            packadd nvim-lspconfig
            luafile ${../config/neovim/lspconfig.lua}
          '';
        } {
          plugin = nvim-lsputils;
          config = builtins.readFile ../config/neovim/lsputils.vim;
        } {
          plugin = nvim-treesitter.overrideAttrs(_: {
            dependencies = [ nvim-treesitter-refactor ];
          });
          config = builtins.readFile ../config/neovim/treesitter.vim;
        } {
          plugin = vimwiki;
          config = ''
            let g:vimwiki_list = [{'path': '~/Documents/vimwiki/',
                \ 'syntax': 'markdown', 'ext': '.md'}]
          '';
        }
        vim-css-color vim-fish vim-jsonnet vim-signify vim-tmux-navigator
      ];
      enable        = true;
      extraPackages =
        let
          packages        = with pkgs; [
            gcc glow gopls metals ripgrep rnix-lsp
          ];
          nodePackages    = with pkgs.nodePackages; [
            bash-language-server
            typescript-language-server
            vim-language-server vscode-css-languageserver-bin
              vscode-html-languageserver-bin vscode-json-languageserver-bin
            yaml-language-server
          ];
        in packages ++ nodePackages;
      package       = pkgs.neovim-nightly;
      vimAlias      = true;
      vimdiffAlias  = true;
      withPython    = false;
      withPython3   = false;
      withRuby      = false;
    };

    ssh = {
      compression         = true;
      controlMaster       = "auto";
      controlPersist      = "yes";
      enable              = true;
      forwardAgent        = true;
      matchBlocks         =
        let key = {
          identitiesOnly = true;
          identityFile   = [ (toString ../config/ssh/id_ed25519) ];
        };
        in {
          dionysus     = key // { hostname = "jupblb.ddns.net"; port = 1995; };
          "github.com" = key;
          hades        = key // { hostname = "jupblb.ddns.net"; port = 1993; };
        };
      serverAliveInterval = 30;
    };

    tmux = {
      baseIndex                 = 1;
      disableConfirmationPrompt = true;
      enable                    = true;
      extraConfig               = builtins.readFile ../config/tmux.conf;
      keyMode                   = "vi";
      plugins                   = with pkgs.tmuxPlugins; [
        pain-control vim-tmux-navigator
      ];
      sensibleOnTop             = false;
      shell                     = "${pkgs.fish}/bin/fish";
      shortcut                  = "Space";
      terminal                  = "screen-256color";
    };
  };

  xdg.configFile."emacs".source = builtins.fetchGit {
    ref = "develop";
    url = https://github.com/hlissner/doom-emacs.git;
  };
}
