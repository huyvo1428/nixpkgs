{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, cython
}:

buildPythonPackage rec {
  pname = "pyclipper";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "48a1b5c585aea10e5b9c0b82d6abe2642fafd9ef158b9921852bc4af815ca20c";
  };

  nativeBuildInputs = [
    setuptools-scm
    cython
  ];

  # Requires pytest_runner to perform tests, which requires deprecated
  # features of setuptools. Seems better to not run tests. This should
  # be fixed upstream.
  doCheck = false;
  pythonImportsCheck = [ "pyclipper" ];

  meta = with lib; {
    description = "Cython wrapper for clipper library";
    homepage    = "https://github.com/fonttools/pyclipper";
    license     = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
