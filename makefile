# conda linux targets aliases
.PHONY: install.rapids
.PHONY: install.linux.rapids
.PHONY: install.linux.pytorch
.PHONY: install.linux.tensorflow
.PHONY: install.linux.dev
# conda linux environments aliases
.PHONY: install.conda.linux.env.pytorch
.PHONY: install.conda.linux.env.tensorflow
.PHONY: install.conda.linux.env.dev
# conda macos targets aliases
.PHONY: install.macos.dev
# conda macos environments aliases
.PHONY: install.conda.macos.env.dev
# conda install aliases
.PHONY: install.conda.macos
.PHONY: install.conda.linux
# conda reinstall aliases
.PHONY: reinstall.conda.linux
.PHONY: reinstall.conda.macos

install.linux.pytorch: install.conda.linux
install.linux.pytorch: install.conda.linux.env.pytorch

install.linux.tensorflow: install.conda.linux
install.linux.tensorflow: install.conda.linux.env.tensorflow

install.linux.dev: install.conda.linux
install.linux.dev: install.conda.linux.env.dev

install.macos.dev: install.conda.macos
install.macos.dev: install.conda.macos.env.dev

install.rapids: install.linux.rapids
install.linux.rapids: install.conda.linux
install.linux.rapids: install.conda.linux.env.rapids

install.conda.linux:
	bash bin/install-conda.sh linux .

install.conda.macos:
	bash bin/install-conda.sh macOS .

reinstall.conda.linux:
	bash bin/install-conda.sh linux . 1

reinstall.conda.macos:
	bash bin/install-conda.sh macOS . 1

install.conda.linux.env.pytorch:
	bash bin/create-env.sh linux ./conda 1 pytorch pytorch-linux.yml

install.conda.linux.env.tensorflow:
	bash bin/create-env.sh linux ./conda 1 tensorflow tensorflow-linux.yml

install.conda.linux.env.dev:
	bash bin/create-env.sh linux ./conda 1 dev dev-linux.yml

install.conda.linux.env.rapids:
	bash bin/create-rapids-env.sh ./conda 1 rapids rapids-linux.yml

install.conda.macos.env.dev:
	bash bin/create-env.sh macOS ./conda 1
