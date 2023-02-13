{ stdenv
, pkgs
, lib
, fetchzip
, unzip
, buildFHSUserEnv
, autoPatchelfHook
, wrapGAppsHook
}:
let 
  pkgIncludes = with pkgs; [
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
in
stdenv.mkDerivation {
  name = "connectiq-sdk-manager";

  src = fetchzip {
    url = "https://developer.garmin.com/downloads/connect-iq/sdk-manager/connectiq-sdk-manager-linux.zip";
    sha256 = "sha256-g43pyQCYC12nkPrRdMz/K036X78n/NVrN/4OlVP8qkw=";
    stripRoot = false;
  };

  nativeBuildInputs = [ autoPatchelfHook wrapGAppsHook ] ++ pkgIncludes;

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out
  '';

  meta = with lib; {
    homepage = https://developer.garmin.com/connect-iq/sdk/; 
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.mglolenstine ];
  };
}
