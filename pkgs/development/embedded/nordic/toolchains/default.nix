{ fetchurl
, lib
, stdenv
, autoPatchelfHook
# Runtime dependencies
, e2fsprogs
, libidn2
, gnutls
, libxcrypt
, gmp
, udev
, libunistring
, db
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "ncs-toolchain";
  version = "2.2.0";

  src = fetchurl{
    url = "https://developer.nordicsemi.com/.pc-tools/toolchain-v2/${pname}-linux-x86_64-v${version}-20221207T155636-f88d497.tar.gz";
    sha256 = "sha256-ICeq6rd3Y+JPHpYmbHsiMo5Rs/pxyjWzoFsZFNp35qY=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  propagatedBuildInputs = [
    e2fsprogs
    libidn2
    gnutls
    libxcrypt
    gmp
    udev
    libunistring
    db
    ncurses
  ];

  installPhase = ''
    mkdir -p $out/
    tar xf $src -C $out/
  '';
  
  meta = with lib; {
    description = "Nordic Toolchain";
    maintainers = with maintainers; [ mglolenstine ];
  };
}
