{
  lib,
  stdenv,
  fetchFromGitHub,
  libusb1,
  pkg-config,
  android-tools,
  zig,
}:

stdenv.mkDerivation rec {
  pname = "droidux";
  version = "572f903";

  src = fetchFromGitHub {
    owner = "leath-dub";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-beijaXRm1tdTMswTCQWxDPl46e18sl0g0KlLdq1/Knk=";
  };

  outputs = [
    "out"
    "udev"
  ];

  nativeBuildInputs = [
    pkg-config
    zig.hook
  ];
  buildInputs = [
    libusb1
  ];

 installPhase = ''
    runHook preInstall
    install -D 00-droidux.rules $out/lib/udev/rules.d/52-droidux.rules
    runHook postInstall
  '';

  zigBuildFlags = [ "-Doptimize=ReleaseFast" ];

  meta = with lib; {
    description = "Create user space drivers for your android devices (digitizer, buttons, etc)";
    longDescription = ''
      To install udev rules, add `services.udev.packages = [ pkgs.droidux.udev ]`
      into `nixos/configuration.nix`.
    '';
    homepage = "https://github.com/leath-dub/droidux";
    license = licenses.mit;
    maintainers = with maintainers; [
       panicketchup
    ];
    platforms = platforms.linux;
  };
}
