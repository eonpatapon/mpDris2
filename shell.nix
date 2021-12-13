let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      (python3.withPackages (ps: with ps; [mpd2 dbus-python pygobject3 mutagen]))
    ];
  }
