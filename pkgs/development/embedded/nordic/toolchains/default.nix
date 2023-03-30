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
  version = "2.3.0";

  src = fetchurl{
    url = "https://developer.nordicsemi.com/.pc-tools/toolchain-v2/${pname}-linux-x86_64-v${version}-20230302T121949-75e5684.tar.gz";
    sha256 = "sha256-da01HK6lOw/vMs+/594UOfYuaB/G6QpvpSm37iYiBYI=";
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
    patchelf --replace-needed libunistring.so.2 libunistring.so.5 $out/usr/lib/x86_64-linux-gnu/libpsl.so.5.3.2
  '';
  
  meta = with lib; {
    description = "Nordic Toolchain";
    maintainers = with maintainers; [ mglolenstine ];
  };
}
