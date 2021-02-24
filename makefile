.PHONY: install.rapids
.PHONY: install.linux.dev
.PHONY: install.macos.dev
.PHONY: install.conda.macos
.PHONY: install.conda.linux
.PHONY: install.conda.macos
.PHONY: install.conda.linux.env.dev
.PHONY: install.conda.macos.env.dev
.PHONY: reinstall.conda.linux
.PHONY: reinstall.conda.macos

install.linux.dev: install.conda.linux
install.linux.dev: install.conda.linux.env.dev

install.macos.dev: install.conda.macos
install.macos.dev: install.conda.macos.env.dev

install.rapids: install.conda.linux
install.rapids: install.conda.linux.env.rapids

install.conda.linux:
	bash bin/install-conda.sh linux .

install.conda.macos:
	bash bin/install-conda.sh macOS .

install.conda.linux.env.dev:
	bash bin/create-dev-env.sh linux ./conda 1

install.conda.macos.env.dev:
	bash bin/create-dev-env.sh macOS ./conda 1

install.conda.linux.env.rapids:
	bash bin/create-rapids-env.sh ./conda 1

reinstall.conda.linux:
	bash bin/install-conda.sh linux . 1

reinstall.conda.macos:
	bash bin/install-conda.sh macOS . 1
