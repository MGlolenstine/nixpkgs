{ lib, stdenv, fetchurl, makeWrapper, perl534, perl534Packages, pkgs }:

stdenv.mkDerivation rec {
  pname = "remotebox";
  version = "3.2";

  src = fetchurl {
    url = "http://remotebox.knobgoblin.org.uk/downloads/RemoteBox-${version}.tar.bz2";
    sha256 = "sha256-nlOPepd4ds6wKxoaBrMgHuNUjsIPpensUvH2YHHsgUg=";
  };

  perlPkgs = with perl534Packages; [
    perl534
    Glib
    Gtk3
    Pango
    SOAPLite
    ClassInspector
    URI
    CairoGObject
    Cairo
    GlibObjectIntrospection
  ];

  buildInputs = perlPkgs;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -pv $out/bin

    substituteInPlace remotebox --replace "\$Bin/" "\$Bin/../"
    echo $PERL5LIB
    install -v -t $out/bin remotebox
    # wrapProgram $out/bin/remotebox --prefix PERL5LIB : "${with perl534Packages; makePerlPath perlPkgs }"

    cp -av docs/ share/ $out

    mkdir -pv $out/share/applications
    cp -pv packagers-readme/*.desktop $out/share/applications
  '';

  postFixup = ''
    wrapProgram $out/bin/remotebox --prefix PERL5LIB : "${with perl534Packages; makePerlPath perlPkgs }"
  '';

  meta = with lib; {
    description = "VirtualBox client with remote management";
    homepage = "http://remotebox.knobgoblin.org.uk/";
    license = licenses.gpl2Plus;
    longDescription = ''
      VirtualBox is traditionally considered to be a virtualization solution
      aimed at the desktop. While it is certainly possible to install
      VirtualBox on a server, it offers few remote management features beyond
      using the vboxmanage command line.
      RemoteBox aims to fill this gap by providing a graphical VirtualBox
      client which is able to manage a VirtualBox server installation.
    '';
    platforms = platforms.all;
  };
}
