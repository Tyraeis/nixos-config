{ inputs, lib, config, pkgs, ... }:
let
    ld-so = pkgs.runCommand "ld.so" {} ''
        mkdir $out
        ln -s "$(cat '${pkgs.stdenv.cc}/nix-support/dynamic-linker')" $out/ld.so
    '';
in {
    environment.systemPackages = [ ld-so ];
    environment.variables.NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.stdenv.cc.cc ];
    environment.variables.NIX_LD = "${ld-so}/ld.so";
}
