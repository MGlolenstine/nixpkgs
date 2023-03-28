{ branch
, libsForQt5
, fetchFromGitHub
, fetchurl
}:

let
  # Fetched from https://api.citra-emu.org/gamedb, last updated 2022-05-02
  # Please make sure to update this when updating citra!
  compat-list = fetchurl {
    name = "citra-compat-list";
    url = "https://web.archive.org/web/20220502114622/https://api.citra-emu.org/gamedb/";
    sha256 = "sha256-blIlaYaUQjw7Azgg+Dd7ZPEQf+ddZMO++Yxinwe+VG0=";
  };
in {
  nightly = libsForQt5.callPackage ./generic.nix rec {
    pname = "citra-nightly";
    version = "1867";

    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = "citra-nightly";
      rev = "nightly-${version}";
      sha256 = "1zlivfnxjjg2h0hi21xcs30w3sdln4s2ncaglh90mbqb2z568qi5";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };

  canary = libsForQt5.callPackage ./generic.nix rec {
    pname = "citra-canary";
    version = "2431";

    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = "citra-canary";
      rev = "canary-${version}";
      sha256 = "1yc86vprj9j7byrpxfc7wp5h71fmvyk3s95417bayj8l83pzijkz";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };
}.${branch}
