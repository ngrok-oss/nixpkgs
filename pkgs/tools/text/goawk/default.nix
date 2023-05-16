{ buildGoModule, fetchFromGitHub, lib, stdenv, gawk }:

buildGoModule rec {
  pname = "goawk";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "benhoyt";
    repo = "goawk";
    rev = "v${version}";
    sha256 = "sha256-uqr4edYPe29YbUm52werxPa/eo1HkR2K34FI43itzVY=";
  };

  vendorHash = null;

  nativeCheckInputs = [ gawk ];

  postPatch = ''
    substituteInPlace goawk_test.go \
      --replace "TestCommandLine" "SkipCommandLine" \
      --replace "TestDevStdout" "SkipDevStdout" \
      --replace "TestFILENAME" "SkipFILENAME" \
      --replace "TestWildcards" "SkipWildcards"

    substituteInPlace interp/interp_test.go \
      --replace "TestShellCommand" "SkipShellCommand"
  '';

  checkFlags = [
    "-awk"
    "${gawk}/bin/gawk"
  ];

  doCheck = (stdenv.system != "aarch64-darwin");

  meta = with lib; {
    description = "A POSIX-compliant AWK interpreter written in Go";
    homepage = "https://benhoyt.com/writings/goawk/";
    license = licenses.mit;
    mainProgram = "goawk";
    maintainers = with maintainers; [ abbe ];
  };
}
