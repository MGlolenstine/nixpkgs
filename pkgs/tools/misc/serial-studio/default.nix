{ pkgs, lib, appimageTools, fetchurl }:

pkgs.appimageTools.wrapType2 rec {
  pname = "serial-studio";
  version = "1.1.7";

  src = fetchurl {
    url = "https://github.com/Serial-Studio/Serial-Studio/releases/download/v${version}/SerialStudio-${version}-Linux.AppImage";
    sha256 = "22b6a9465b9b56bb321956991f6746117f7f084d56082b28000bed0908919be8";
  };

  meta = with lib; {
    homepage = "https://serial-studio.github.io";
    changelog = "https://github.com/Serial-Studio/Serial-Studio/releases";
    description = "A nice Serial terminal for developers and makers";
    license = licenses.mit;
    maintainers = with maintainers; [ mglolenstine ];
    platforms = platforms.linux;
  };

  profile = ''
    export QT_XCB_GL_INTEGRATION=none
    export LC_ALL=C.UTF-8
  '';
}