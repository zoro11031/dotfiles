

{ lib
, mpv
, stdenv
, mkDerivation
, qtbase
, qttools
, qtx11extras
, qmake
, sqlite
, fetchFromGitHub
, json-c
, libzip
, mecab
, mecab-ipadic
, meson
, mpv
, ninja
, nix-update-script
, pkg-config
, python3
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "memento";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ripose-jp";
    repo = "Memento";
    rev = "v${version}";
    sha256 = "7cc9a338899ed4f0a87fb43c1dd25183220570225801f2d1e50083a91359f74c";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    meson
    ninja
    pkg-config
    qmake
    qttools
  ];

  buildInputs = [
    qtbase
    qtx11extras
    mpv
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib;
 {
    description = "Memento is a FOSS, mpv-based video player for studying Japanese.";
    homepage = "https://github.com/ripose-jp/Memento";
    license = licenses.gpl2;
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ ripose-jp ];
  };
}
