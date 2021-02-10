# conda environment utilities

---

`bash install-conda.sh TARGET_OS PREFIX`

---

## `install-conda.sh` positional options

1. `TARGET_OS`: one of `[linux, macOS]`; specify which script to pull from Anaconda for installation.
2. `PREFIX`: the installation prefix for conda; `PATH` would install `conda` under `PATH/conda`.

---

`bash create-dev-env.sh TARGET_OS CC CXX CONDA`

---

## `create-dev-env.sh` positional arguments

1. `TARGET_OS`: one of `[linux, macOS]`; specify which Anaconda environmetnt specification file to use under `conda/environments`.
2. `CC`: the path to a valid C compiler for building `quantumlib/qsim`.
3. `CXX`: the path to a valid C++ compiler for building `quantumlib/qsim`.
4. `CONDA`: the path to the `conda` root directory; (ex.) `PATH/conda`.

