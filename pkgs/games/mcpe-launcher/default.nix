{  fetchurl
,  appimageTools
}:
appimageTools.wrapType2 rec {
  name = "mcpe-launcher";
  version = "0.14.2-792";

  src = fetchurl {
    url = "https://github.com/minecraft-linux/appimage-builder/releases/download/v${version}/Minecraft_Bedrock_Launcher-x86_64-v${builtins.replaceStrings ["-"] ["."] version}.AppImage";
    hash = "sha256-7tEaULa5wPQbKPpa7RJL5cBcYBfQuWW9xD/cHCgX5KE=";
  };
  extraPkgs = pkgs: with pkgs; [
    curl
    zlib
    glibc
    gcc-unwrapped
    libsForQt5.qtbase
    libsForQt5.qtdeclarative
  ];
}
