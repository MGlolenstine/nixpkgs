{ lib
, stdenv
, fetchurl
, cups
, dpkg
, gnused
, makeWrapper
, ghostscript
, file
, a2ps
, coreutils
, gnugrep
, which
, gawk
}:

let
  version = "3.0.0";
  model = "dcpj105";
in
rec {
  driver = stdenv.mkDerivation {
    pname = "${model}-lpr";
    inherit version;

    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf100912/${model}lpr-${version}-1.i386.deb";
      sha256 = "3de559fffb316c4fad4d71174d025d0f7c04204c1cd3dca1805f5f736ea5e794";
    };

    nativeBuildInputs = [ dpkg makeWrapper ];
    buildInputs = [ cups ghostscript a2ps gawk ];
    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      substituteInPlace $out/opt/brother/Printers/${model}/lpd/filter${model} \
      --replace /opt "$out/opt"

      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/${model}/lpd/br${model}filter

      mkdir -p $out/lib/cups/filter/
      ln -s $out/opt/brother/Printers/${model}/lpd/filter${model} $out/lib/cups/filter/brother_lpdwrapper_${model}

      wrapProgram $out/opt/brother/Printers/${model}/lpd/filter${model} \
        --prefix PATH ":" ${lib.makeBinPath [
          gawk
          ghostscript
          a2ps
          file
          gnused
          gnugrep
          coreutils
          which
        ]}
    '';

    meta = with lib; {
      homepage = "http://www.brother.com/";
      description = "Brother ${model} printer driver";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.unfree;
      platforms = platforms.linux;
      downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=${model}_eu&os=128";
      maintainers = with maintainers; [ pshirshov ];
    };
  };

  cupswrapper = stdenv.mkDerivation {
    pname = "${model}-cupswrapper";
    inherit version;

    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf100913/${model}cupswrapper-${version}-1.i386.deb";
      sha256 = "cb2afdcc2cd4f2b58e67626051a1b9ece65ad0de3f3fcda75a12c113a622ec01";
    };

    nativeBuildInputs = [ dpkg makeWrapper ];
    buildInputs = [ cups ghostscript a2ps gawk ];
    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      for f in $out/opt/brother/Printers/${model}/cupswrapper/cupswrapper${model}; do
        wrapProgram $f --prefix PATH : ${lib.makeBinPath [ coreutils ghostscript gnugrep gnused ]}
      done

      mkdir -p $out/share/cups/model
      ln -s $out/opt/brother/Printers/${model}/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model/
    '';

    meta = with lib; {
      homepage = "http://www.brother.com/";
      description = "Brother ${model} printer CUPS wrapper driver";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.unfree;
      platforms = platforms.linux;
      downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=${model}_eu&os=128";
      maintainers = with maintainers; [ pshirshov ];
    };
  };
}