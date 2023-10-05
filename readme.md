envs
----
download and install conda and then create a user-defined environment with one command:

```bash
make install.env from=./env.yml
```

after doing this, source your bashrc: `source ~/.bashrc` or restart your shell

- an environment called `default` will be created
- activate it with: `conda activate default`
- deactivate it with: `conda deactivate default`
- delete it with: `conda env remove --name default`
- purge and reinstall conda with: `make reinstall.conda`
