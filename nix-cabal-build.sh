#!/bin/bash

cabal=$(echo *.cabal)

if [[ ! -f default.nix ]]; then
    cabal2nix --sha256=X ./$cabal > default.nix
    sed -i 's#sha.*#src = builtins.filterSource (path: type: type != "unknown") ./.;#' default.nix
fi

nix-build -E 'let pkgs = import <nixpkgs> {}; in pkgs.stdenv.lib.callPackageWith (pkgs // pkgs.haskellPackages) ./default.nix {}'
