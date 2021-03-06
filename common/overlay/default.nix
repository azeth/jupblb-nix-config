self: super: rec {
  chromium-wayland = super.callPackage ./chromium-wayland/default.nix {};
  emacs-wrapped    = super.callPackage ./emacs {};
  fishPlugins      = import ./fish { inherit (super) callPackage; };
  lf               = super.callPackage ./lf { lf = super.lf; };
  htop             = super.callPackage ./htop { htop = super.htop; };
  neovim-nightly   = super.callPackage ./neovim {};
  pragmata-pro     = super.callPackage ./pragmata-pro {};
}
