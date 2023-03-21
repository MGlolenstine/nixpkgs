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

  buildPhase = ''
    mkdir -p $out/sdk
    mkdir -p $out/lib/cmake

    cp $src $out/sdk/west.yml
    west -v init -l $out/sdk/
    cd $out/sdk
    west -v update

    # Redirect to the package and not $HOME
    echo "sed -i \"s,\$ENV{HOME}/.cmake,$out/lib/cmake,g\" $out/zephyr/share/zephyr-package/cmake/zephyr_export.cmake"
    echo "sed -i \"s,~/.cmake,$out/lib/cmake,g\" $out/zephyr/share/zephyr-package/cmake/zephyr_export.cmake"
    echo sed -i 's,\$\{CMAKE_CURRENT_LIST_DIR\}/\$\{MD5_INFILE\},'$out'/tmp/\$\{MD5_INFILE\},g' $out/zephyr/share/zephyr-package/cmake/zephyr_export.cmake
    
    sed -i "s,\$ENV{HOME}/.cmake,$out/lib/cmake,g" $out/zephyr/share/zephyr-package/cmake/zephyr_export.cmake
    sed -i "s,~/.cmake,$out/lib/cmake,g" $out/zephyr/share/zephyr-package/cmake/zephyr_export.cmake
    sed -i 's,\$\{CMAKE_CURRENT_LIST_DIR\}/\$\{MD5_INFILE\},'$out'/tmp/\$\{MD5_INFILE\},g' $out/zephyr/share/zephyr-package/cmake/zephyr_export.cmake
    
    west -v zephyr-export
  '';
}