#!/bin/bash -e

CACHE=/Volumes/mybook/Products/nix-binary-cache

if [[ -d $CACHE ]]; then
    for i in $(nix-env -q); then
    nix-push --dest $CACHE                                                      \
             --key-file ~/.nix/sk                                               \
             --manifest                                                         \
             --url-prefix http://ftp.newartisans.com/pub/nix-binary-cache       \
             $(readlink -f ~/.nix-profile)

    (cd ~/.nix-defexpr/nixpkgs ; git rev-parse HEAD) > $CACHE/commit.txt

    exec rsync -aP --delete $CACHE/ jw:/srv/ftp/pub/nix-binary-cache/
fi