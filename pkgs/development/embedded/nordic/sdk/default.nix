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
    # outputHash = "sha256-/fOg0wjfPDXqvYUuuznnbHuu2Fa4Tz69xOPYoQ0HrBE=";
    outputHash = lib.fakeHash;
  };

  dontUnpack = true;
  
  propagatedBuildInputs = [
    python3
    python3.pkgs.west
    git
  ];

  # writeScriptBin "install-sdk" 
  #   ''
  #     OUT=$HOME/.ncs-sdk/${version}
  #     mkdir -p $OUT
  #     cp $src $OUT/west.yml
  #     west -v init -l $OUT/west.yml
  #     PREVIOUS_DIR=$(pwd)
  #     cd $OUT
  #     west -v update
  #     west -v zephyr-export
  #     cd $PREVIOUS_DIR
  #   '';

  # buildPhase = ''
  #   mkdir -p $out/sdk
  #   mkdir -p $out/bin

  #   chmod 664 $src
  #   cp $src $out/sdk/west.yml

  #   cat << EOF > $out/bin/install-sdk
  #   OUT=\$HOME/.ncs-sdk/${version}
  #   mkdir -p \$OUT
  #   cp $src \$OUT/west.yml
  #   west -v init -l \$OUT
  #   PREVIOUS_DIR=\$(pwd)
  #   cd \$OUT
  #   west -v update
  #   west -v zephyr-export
  #   cd \$PREVIOUS_DIR
  #   EOF

  #   chmod +x $out/bin/install-sdk
  # '';

  meta = with lib; {
    description = "Nordic SDK";
    maintainers = with maintainers; [ mglolenstine ];
  };
}
