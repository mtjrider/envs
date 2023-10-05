.PHONY: install.env
.PHONY: install.python
# conda linux targets aliases
.PHONY: install.linux.env
.PHONY: install.linux.python-3.9
# conda linux environments aliases
.PHONY: install.conda.linux.env
.PHONY: install.conda.linux.env.python-3.9
# conda install aliases
.PHONY: install.conda.linux
# conda reinstall aliases
.PHONY: reinstall.conda.linux

install.env: SHELL:=/usr/bin/env bash
install.env: install.linux.env
install.linux.env: install.conda.linux
install.linux.env: install.conda.linux.env

install.python: SHELL:=/usr/bin/env bash
install.python: install.linux.python-3.9
install.linux.python-3.9: install.conda.linux
install.linux.python-3.9: install.conda.linux.env.python-3.9

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

install.conda.linux.env:
	@if [[ -f ${from} ]]; then \
		echo "creating environment from file ${from}" && \
		bash bin/utils/create_conda_env \
			--clear-cache true \
			--env-file ${from}; \
	else \
		echo "provided path ${from} is not a file"; \
	fi

install.conda.linux.env.python-3.9:
	bash bin/utils/create_conda_env \
		--clear-cache true \
		--env-file .conda/environments/linux-python-3.9.yml
