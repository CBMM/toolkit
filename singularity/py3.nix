{ pkgs ? import <nixpkgs> {} }:

let singularity = import ./. { inherit pkgs; };
in with singularity.pkgs; singularity.buildImage {
    name = "py3";
    runScript = ''
      exec /usr/bin/python "$@"
    '';
    contents = [ python36 ];
}
