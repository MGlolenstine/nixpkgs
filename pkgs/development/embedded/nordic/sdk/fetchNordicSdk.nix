{ lib
, pkgs
, stdenv
, hash ? ""
, outputHash ? ""
, pname ? ""
, version ? ""
}:
stdenv.mkDerivation {
  inherit outputHash; outputHashMode = "recursive"; outputHashAlgo = "sha256";
  inherit pname version;

  dontUnpack = true;
  
  src = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/nrfconnect/sdk-nrf/v${version}/west.yml";
    sha256 = "sha256-Vximc9TeGV7E6YXoibhnwHMz0+OUDylC66AfxHhI6LI=";
  };

  dontUseCmakeConfigure = true;
  
  nativeBuildInputs = with pkgs; [
    cacert
    cmake
  ];

  buildInputs = with pkgs; [
    python3.pkgs.west
    gitFull
  ];

  propagatedBuildInputs = with pkgs; [
    python3.pkgs.west
  ];

  buildPhase = ''
    mkdir -p $out/sdk

    cp $src $out/sdk/west.yml
    west -v init -l $out/sdk/
    cd $out/sdk
    west -v update
    west -v zephyr-export
  '';
}