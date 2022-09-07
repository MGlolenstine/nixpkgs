{ stdenv
, lib
, fetchurl
, unzip
, zlib
, curl
, libsecret
, gcc
, expat
, glib
, xorg_sys_opengl
, gtk2-x11
, xorg
, atk
, freetype
, libpng
, cairo
, gnome2
, gdk-pixbuf
, webkitgtk
, fontconfig
, libjpeg8
, glib-networking
, libusb
, autoPatchelfHook
}:
stdenv.mkDerivation rec {
  name = "connectiq-sdk";
  version = "4.1.5-2022-08-03-6e17bf167";
  
  src = fetchurl {
    url = "https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-${version}.zip";
    sha256 = "sha256-NZkHelL2jLfjcAHUB7tJig07EgeeWFFylb3AD06TgWU=";
  };
  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;
  
  nativeBuildInputs = [unzip];

  unpackPhase = ''
    unzip ${src}
  '';

  installPhase = ''
    mkdir -p $out/opt
    mkdir -p $out/bin
    cp -r * $out/opt
    ln -s $out/opt/bin/barrelbuild $out/bin/barrelbuild
    ln -s $out/opt/bin/barreltest $out/bin/barreltest
    ln -s $out/opt/bin/connectiq $out/bin/connectiq
    ln -s $out/opt/bin/era $out/bin/era
    ln -s $out/opt/bin/mdd $out/bin/mdd
    ln -s $out/opt/bin/monkeyc $out/bin/monkeyc
    ln -s $out/opt/bin/monkeydo $out/bin/monkeydo
    ln -s $out/opt/bin/monkeydoc $out/bin/monkeydoc
    ln -s $out/opt/bin/monkeygraph $out/bin/monkeygraph
    ln -s $out/opt/bin/monkeymotion $out/bin/monkeymotion
  
    ln -s $out/opt/bin/shell $out/bin/shell
    ln -s $out/opt/bin/simulator $out/bin/simulator
  '';
  buildInputs = [
      zlib
      curl
      libsecret
      gcc
      expat
      glib
      xorg_sys_opengl
      gtk2-x11
      xorg.libX11
      xorg.libXxf86vm
      xorg.libSM
      atk
      freetype
      libpng
      cairo
      gnome2.pango
      gdk-pixbuf
      webkitgtk
      gnome2.libsoup
      fontconfig
      libjpeg8
      glib-networking
      libusb
      autoPatchelfHook
  ];

  meta = with lib; {
    homepage = https://developer.garmin.com/connect-iq/sdk/; 
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}