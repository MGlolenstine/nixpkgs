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
    cmake
  ];

  # build phases
  phases = [
    "createFoldersPhase"
    "initPhase"
  ];

  createFoldersPhase = ''
    mkdir -p $out/sdk/manifest
    mkdir -p $out/lib/cmake
  '';

  initPhase = ''
    cp $src $out/sdk/manifest/west.yml
    cd $out/sdk
    echo $(pwd)
    west -v init -l manifest
    west -v update
    find . -name ".git" -type d -exec rm -rf {} +

    ls -lah
    ls -lah ..
    echo `pwd`
    cp -a $out/sdk /build/sdk
    ls -lah /build/sdk
  '';
}