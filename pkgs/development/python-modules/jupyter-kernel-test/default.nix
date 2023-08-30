{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
, gcc
}:

buildPythonPackage rec {
  pname = "jupyter-kernel-test";
  version = "0.6.0";

  src = fetchPypi {
    pname = "jupyter_kernel_test";
    inherit version;
    sha256 = "e4b34235b42761cfc3ff08386675b2362e5a97fb926c135eee782661db08a140";
  };

  # no tests in repository
  doCheck = false;

  meta = with lib; {
    description = "A tool for testing Jupyter kernels";
    homepage = "https://github.com/jupyter/jupyter_kernel_test";
    license = licenses.bsd3;
    maintainers = [ thomasjm ];
  };
}
