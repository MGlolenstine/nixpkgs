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
, gtk3-x11
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
}:
stdenv.mkDerivation rec {
  name = "connectiq-sdk-manager";

  src = fetchurl {
    url = "https://developer.garmin.com/downloads/connect-iq/sdk-manager/connectiq-sdk-manager-linux.zip";
    sha256 = "8e51e167011965c44ed108be021cfbca9e89bc03ce1d4e29edde9b2c257e1c9a";
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
    cp -r bin $out/opt
    cp -r share $out/opt
    ln -s $out/opt/bin/sdkmanager $out/bin/sdkmanager
  '';

  preFixup = let
    libPath = lib.makeLibraryPath [
      zlib
      curl
      libsecret
      gcc
      expat
      glib
      xorg_sys_opengl
      gtk3-x11
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
      stdenv.cc.cc.lib
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/bin/sdkmanager
  '';

  meta = with lib; {
    homepage = https://developer.garmin.com/connect-iq/sdk/; 
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}