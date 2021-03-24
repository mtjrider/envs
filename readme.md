# conda environment utilities

---

`make install.rapids`

Installs conda, and the builds a conda environment called `rapids` with packages specified by `conda-environments/rapids-linux.yml`

Note: this command is an alias for `make install.linux.rapids`, and only works on a linux distribution

---

`make install.linux.{pytorch, tensorflow, dev}`

Installs conda, and the builds a conda environment called `{pytorch, tensorflow, dev}` with packages specified by `conda-environments/{pytorch, tensorflow, dev}-linux.yml`

Ex.) `make install.linux.tensorflow` installs conda, builds a conda environment called `tensorflow` with packages specified by `conda-environments/tensorflow-linux.yml`

---

`make install.macos.dev`

Installs conda, and the builds a conda environment called `dev` with packages specified by `conda-environments/dev-macos.yml`
