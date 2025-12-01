{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, binaryen
, cargo
, libfido2
, nodejs
, openssl
, pkg-config
, wasm-pack
, wasm-bindgen-cli
, rustc
, stdenv
, nixosTests
, xdg-utils
, buildGo124Module
}:
let
  name = "teleport";
  pname = "teleport";
  version = "15.5.4";
  buildGoModule = buildGo124Module;

  src = fetchFromGitHub {
    owner = "gravitational";
    repo  = "teleport";
    tag   = "v${version}";
    hash  = ""; # fill in after first build
  };
  yarnOfflineCache = stdenv.mkDerivation {
    pname = "teleport-webassets-yarn-cache";
    src = "${src}/web";
    buildCommand = ''
      mkdir -p $out
      cp -r $src/* $out/
    '';
    hash = ""; # fill after first build
  };

  rdpClient = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "teleport-rdpclient";
    inherit version src;
    cargoHash = ""; # fill in

    buildAndTestSubdir = "lib/srv/desktop/rdp/rdpclient";

    buildInputs = [ openssl ];
    nativeBuildInputs = [ pkg-config ];
    nativeCheckInputs = finalAttrs.buildInputs;

    OPENSSL_NO_VENDOR = "1";

    postInstall = ''
      mkdir -p $out/include
      cp ${finalAttrs.buildAndTestSubdir}/librdpclient.h $out/include/
    '';
  });

  webassets = stdenv.mkDerivation {
    pname = "teleport-webassets";
    inherit src version;
    name = "teleport-webassets-${version}";

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit src;
      hash = ""; # fill in
    };

    nativeBuildInputs = [
      binaryen
      cargo
      nodejs
      rustc
      rustc.llvmPackages.lld
      rustPlatform.cargoSetupHook
      wasm-bindgen-cli
      wasm-pack
    ];

    patches = [ ./disable-wasm-opt-for-ironrdp.patch ];

    yarnOfflineCache = stdenv.mkDerivation {
      pname = "teleport-webassets-yarn-cache";
      src = "${src}/web";
      buildCommand = ''
        mkdir -p $out
        cp -r $src/* $out/
      '';
      hash = ""; # fill in
    };

    buildPhase = ''
      export HOME=$(mktemp -d)
      PATH=$PATH:$PWD/node_modules/.bin

      yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
      yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts

      pushd web/packages/shared
      RUST_MIN_STACK=16777216 wasm-pack build ./libs/ironrdp --target web --mode no-install
      popd
      pushd web/packages/teleport
      vite build
      popd
      popd
    '';

    installPhase = ''
      mkdir -p $out
      cp -R webassets/. $out
    '';
  };
in

buildGoModule (finalAttrs: {
  inherit pname src version;
  name = "${pname}-${version}";
  vendorHash = null; # fill in

  proxyVendor = true;

  subPackages = [
    "tool/tbot"
    "tool/tctl"
    "tool/teleport"
    "tool/tsh"
  ];

  tags = [
    "libfido2"
    "webassets_embed"
  ] ++ lib.optional true "desktop_access_rdp";

  buildInputs = [
    openssl
    libfido2
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  patches = [
  ];

  outputs = [ "out" "client" ];

  preBuild = ''
    cp -r ${webassets} webassets
    ln -s ${rdpClient}/lib/* lib/
    ln -s ${rdpClient}/include/* lib/srv/desktop/rdp/rdpclient/
  '';

  doCheck = false;

  postInstall = ''
    mkdir -p $client/bin
    mv {$out,$client}/bin/tsh
    wrapProgram $client/bin/tsh --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
    ln -s {$client,$out}/bin/tsh
  '';

  doInstallCheck = false;

  passthru.tests = nixosTests.teleport;

  meta = {
    description = "Certificate authority and access plane for SSH, Kubernetes, web applications, and databases";
    homepage    = "https://goteleport.com/";
    license     = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ arianvp justinas sigma tomberek techknowlogick juliusfreudenberger ];
    platforms   = lib.platforms.unix;
    broken      = stdenv.hostPlatform.parsed.cpu.bits < 64;
  };
})

