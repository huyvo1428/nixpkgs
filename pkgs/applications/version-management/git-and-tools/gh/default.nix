{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "gh";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-/czexUqpdsFQAteZ75ur2SFibrtZWffHpPBEPlLQXSY=";
  };

  vendorSha256 = "sha256-slMl5dCyyVNBgDbpYECfYUbpJJ7sWuSGSutYR3rTzj0=";

  nativeBuildInputs = [ installShellFiles ];

  # upstream unsets these to handle cross but it breaks our build
  postPatch = ''
    substituteInPlace Makefile \
      --replace "GOOS= GOARCH= GOARM= GOFLAGS= CGO_ENABLED=" ""
  '';

  buildPhase = ''
    runHook preBuild
    make GO_LDFLAGS="-s -w" GH_VERSION=${version} bin/gh manpages
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/gh -t $out/bin
    installManPage share/man/*/*.[1-9]

    for shell in bash fish zsh; do
      $out/bin/gh completion -s $shell > gh.$shell
      installShellCompletion gh.$shell
    done
    runHook postInstall
  '';

  # fails with `unable to find git executable in PATH`
  doCheck = false;

  meta = with lib; {
    description = "GitHub CLI tool";
    homepage = "https://cli.github.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
