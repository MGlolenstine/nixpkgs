{  fetchurl
,  appimageTools
}:
appimageTools.wrapType2 rec {
  name = "mcpe-launcher";
  version = "0.10.0-716";

  src = fetchurl {
    url = "https://github.com/minecraft-linux/appimage-builder/releases/download/v${version}/Minecraft_Bedrock_Launcher-x86_64-v${builtins.replaceStrings ["-"] ["."] version}.AppImage";
    hash = "sha256-kHJJau1WMATbqz5L1QSURbG7OC+cHV4tKvdolNzltA4=";
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
