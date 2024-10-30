{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "ffpb";
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7eVqbLpMHS1sBw2vYS4cTtyVdnnknGtEI8190VlXflk=";
  };

  propagatedBuildInputs = [ python3Packages.tqdm ];

  # tests require working internet connection
  doCheck = false;

  meta = {
    description = "FFmpeg progress formatter to display a nice progress bar and an adaptative ETA timer";
    homepage = "https://github.com/althonos/ffpb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ CaptainJawZ ];
    mainProgram = "ffpb";
  };
}
