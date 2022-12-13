{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hjson-go";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "hjson";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WR6wLa/Za5MgcH1enHG/74uq/7PdaY/OzvJdgMgDFIk=";
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Utility to convert JSON to and from HJSON";
    homepage = "https://hjson.github.io/";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.mit;
    mainProgram = "hjson-cli";
  };
}
