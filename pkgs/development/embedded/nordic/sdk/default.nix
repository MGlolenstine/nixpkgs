{ fetchurl
, lib
, stdenv
, python3
, git
, ncs-toolchain
, pkgs
}:
let 
  fetchNordicSdk = import ./fetchNordicSdk.nix;
in
stdenv.mkDerivation rec {
  pname = "ncs-sdk";
  version = "2.2.0";
  
  src = fetchNordicSdk {
    inherit pname version lib stdenv pkgs;
    outputHash = "sha256-ghVSoL5XUutm3kHOasGgf9jYRw4/iMamNmDMVS19dTk=";
  };

  dontUnpack = true;
  
  propagatedBuildInputs = [
    python3
    python3.pkgs.west
    git
  ];

  phases = [
    "buildPhase"
    "zephyrExport"
  ];

  buildPhase = ''
    mkdir -p $out
    cp -a $src/sdk $out/
    
    mkdir -p $out/lib/cmake/packages
  '';
    
  zephyrExport = ''
    set -e

    PWD=$out/sdk/zephyr/share/zephyr-package/cmake

    hash=$(echo "$PWD" | md5sum | cut -d ' ' -f 1)

    if [ "$(uname)" = "Darwin" ]; then
      defaults write org.cmake.packages -dict-add Zephyr "$PWD"
    else
      mkdir -p $out/lib/cmake/packages/Zephyr
      echo "$PWD" > $out/lib/cmake/packages/Zephyr/$hash
    fi

    echo "Zephyr ($PWD)"
    echo "has been added to the user package registry in:"
    if [ "$(uname)" = "Darwin" ]; then
      echo "defaults read org.cmake.packages Zephyr"
    else
      echo "$out/lib/cmake/packages/Zephyr"
    fi
  '';

  meta = with lib; {
    description = "Nordic SDK";
    maintainers = with maintainers; [ mglolenstine ];
  };
}
