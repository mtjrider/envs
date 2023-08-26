.PHONY: install.pytorch-cpu
.PHONY: install.pytorch-cuda
# conda linux targets aliases
.PHONY: install.linux.pytorch-cpu
.PHONY: install.linux.pytorch-cuda-11.7
.PHONY: install.linux.pytorch-cuda-11.8
# conda linux environments aliases
.PHONY: install.conda.linux.env.pytorch-cpu
.PHONY: install.conda.linux.env.pytorch-cuda-11.7
.PHONY: install.conda.linux.env.pytorch-cuda-11.8
# conda install aliases
.PHONY: install.conda.linux
# conda reinstall aliases
.PHONY: reinstall.conda.linux

install.pytorch-cpu: install.linux.pytorch-cpu
install.pytorch-cuda: install.linux.pytorch-cuda-11.8

install.linux.pytorch-cpu: install.conda.linux
install.linux.pytorch-cpu: install.conda.linux.env.pytorch-cpu

install.linux.pytorch-cuda-11.7: install.conda.linux
install.linux.pytorch-cuda-11.7: install.conda.linux.env.pytorch-cuda-11.7

install.linux.pytorch-cuda-11.8: install.conda.linux
install.linux.pytorch-cuda-11.8: install.conda.linux.env.pytorch-cuda-11.8

install.conda.linux:
	bash bin/utils/install_conda \
		--reinstall default \
		--operating-system linux \
		--source-url https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

reinstall.conda.linux:
	bash bin/utils/install_conda \
		--reinstall true \
		--operating-system linux \
		--source-url https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

install.conda.linux.env.pytorch-cpu:
	bash bin/utils/create_conda_env \
		--clear-cache true \
		--env-file conda-environments/linux-pytorch-cpu.yml

install.conda.linux.env.pytorch-cuda-11.7:
	bash bin/utils/create_conda_env \
		--clear-cache true \
		--env-file conda-environments/linux-pytorch-cu117.yml

install.conda.linux.env.pytorch-cuda-11.8:
	bash bin/utils/create_conda_env \
		--clear-cache true \
		--env-file conda-environments/linux-pytorch-cu118.yml
