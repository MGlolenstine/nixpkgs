{ lib
, stdenv
, fetchurl
, appimageTools
}:

let
  pname = "nrfconnect";
  version = "4.0.0";

  src = fetchurl {
    url = "https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-connect-for-desktop/${lib.versions.major version}-${lib.versions.minor version}-${lib.versions.patch version}/nrfconnect-${version}-x86_64.appimage";
    sha256 = "sha256-byOvnUYmkpvYK/Nwth1r+SksWusdQaLxPPHFw6thIxo=";
    name = "${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

in appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [
    python3
    python310Packages.west
    segger-jlink
  ];

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/nrfconnect.desktop $out/share/applications/nrfconnect.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/nrfconnect.png \
      $out/share/icons/hicolor/512x512/apps/nrfconnect.png
    substituteInPlace $out/share/applications/nrfconnect.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Nordic Semiconductor nRF Connect for Desktop";
    homepage = "https://www.nordicsemi.com/Products/Development-tools/nRF-Connect-for-desktop";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ stargate01 ];
  };
}
