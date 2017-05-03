{ pkgs ? import <nixpkgs> {} }:
with pkgs; rec {
  inherit pkgs;

  mkGzip = name: file: stdenv.mkDerivation {
    name = "${name}.gz";

    input = file;

    builder = builtins.toFile "builder.sh" ''
      source "$stdenv/setup"
      gzip -c9 "$input" >"$out"
    '';

    buildInputs = [
      gzip
    ];
  };

  buildImage = { name
               , diskSize ? 8192
               , contents ? []
               , runScript ? "#!${stdenv.shell}\nexec /bin/sh"
               , runAsRoot ? ''
                   mkdir /om
                   mkdir /cm
                 ''
               , extraSpace ? 0
               }:
    let singImg = pkgs.singularity-tools.buildImage {
          inherit name diskSize contents runScript runAsRoot extraSpace;
        };
    in mkGzip name singImg;
}
