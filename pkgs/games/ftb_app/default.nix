{ lib, stdenv
, fetchurl
, jdk17
, dpkg
, copyDesktopItems
, autoPatchelfHook
, pkgs
}:
# let
  # desktopItem = makeDesktopItem {
  #   name = "FTB App";
  #   exec = "FTBApp";
  #   icon = "ftb-app";
  #   comment = "Official launcher for FTB, a Minecraft modpack launcher";
  #   desktopName = "FTB Launcher";
  #   categories = [ "Game" ];
  # };
# in
stdenv.mkDerivation rec {
  pname = "ftb_app";

  version = "202308291248-1903496f17";

  src = fetchurl {
    url = "https://apps.modpacks.ch/FTBApp/release/${version}/FTBA_linux_${version}.deb";
    sha256 = "sha256-GW8vTCvXhlpk5YPa5ZM5j/gVC2mPmWnwdYFzGDubY48=";
    # sha256 = lib.fakeHash;
  };

  nativeBuildInputs = [
    jdk17
    dpkg
    autoPatchelfHook

    pkgs.glib
    pkgs.nss
    pkgs.electron
    pkgs.at-spi2-atk
    pkgs.cups.lib
    pkgs.dbus.lib
    pkgs.libdrm
    pkgs.gtk3
    pkgs.pango
    pkgs.cairo
    pkgs.mesa
    pkgs.alsa-lib
    pkgs.ffmpeg
    pkgs.xorg.libXtst
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    dpkg -x $src /build
    cp -rav /build/opt/FTBA/. $out/bin
    chmod +x $out/bin/bin/ftb-app
  '';

  # desktopItems = [ desktopItem ];

  meta = with lib; {
    description = "Official launcher for FTB, a Minecraft modpack launcher";
    homepage = "https://www.feed-the-beast.com/ftb-app";
    maintainers = with maintainers; [ mglolenstine ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
