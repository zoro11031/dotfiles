
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
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    qtbase
    qtx11extras
    mpv
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };
