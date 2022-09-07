{ lib, stdenv, fetchurl, static ? false }:

stdenv.mkDerivation rec {
  pname = "libjpeg";
  version = "8d";

  src = fetchurl {
    url = "http://www.ijg.org/files/jpegsrc.v${version}.tar.gz";
    sha256 = "sha256-/cTUwRM4rQKKfSP7U/W7k1RnE5Kmf7G1LgwypxIYkfg=";
  };

  configureFlags = lib.optional static "--enable-static --disable-shared";

  outputs = [ "bin" "dev" "out" "man" ];

  meta = with lib; {
    homepage = "https://www.ijg.org/";
    description = "A library that implements the JPEG image file format";
    maintainers = with maintainers; [ ];
    license = licenses.free;
    platforms = platforms.unix;
  };
}
