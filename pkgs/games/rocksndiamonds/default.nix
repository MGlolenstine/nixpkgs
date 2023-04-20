{ lib, stdenv, fetchurl, fetchpatch, makeDesktopItem, SDL2, SDL2_image, SDL2_mixer, SDL2_net, zlib }:

stdenv.mkDerivation rec {
  pname = "rocksndiamonds";
  version = "4.3.5.4";

  src = fetchurl {
    url = "https://www.artsoft.org/RELEASES/linux/${pname}/rocksndiamonds-${version}-linux.tar.gz";
    sha256 = "sha256-yfi4GIvDQdo9AEq1vdPppvYcIkPH8BCIJin2pq6h7Ko=";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = meta.description;
    desktopName = "Rocks'n'Diamonds";
    genericName = "Tile-based puzzle";
    categories = [ "Game" "LogicGame" ];
  };

  buildInputs = [ SDL2 SDL2_image SDL2_mixer SDL2_net zlib ];

  preBuild = ''
    dataDir="$out/bin"
    makeFlags+="RO_GAME_DIR=$dataDir"
  '';

  installPhase = ''
    appDir=$out/share/applications
    iconDir=$out/share/icons/hicolor/32x32/apps
    mkdir -p $appDir $iconDir $dataDir
    ln -s ${desktopItem}/share/applications/* $appDir/
    ln -s $dataDir/graphics/gfx_classic/RocksIcon32x32.png $iconDir/rocksndiamonds.png
    cp -r rocksndiamonds docs graphics levels music sounds $dataDir
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Scrolling tile-based arcade style puzzle game";
    homepage = "https://www.artsoft.org/rocksndiamonds/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
