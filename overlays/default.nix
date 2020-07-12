self: pkgs: with pkgs; { 
  bazel-compdb' = callPackage ./bazel-compdb {};
  doom-emacs'   = callPackage ./emacs {};
  ranger'       = callPackage ./ranger {};
  sway'         = callPackage ./sway {};
}
