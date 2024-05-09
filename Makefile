# Copyright 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

INSTALL_PREFIX = -DCMAKE_INSTALL_PREFIX=_install

.PHONY: all
all: googletest tdi

.PHONY: googletest
googletest:
	cmake -B _build/googletest -S googletest ${INSTALL_PREFIX}
	cmake --build _build/googletest --target install

.PHONY: zlog
zlog:
	cmake -B _build/zlog -S zlog ${INSTALL_PREFIX}
	cmake --build _build/zlog --target install

.PHONY: targetsys
targetsys: zlog
	cmake -B _build/targetsys -S target-syslibs ${INSTALL_PREFIX}
	cmake --build _build/targetsys --target install

.PHONY: targetutils
targetutils: targetsys
	cmake -B _build/targetutils -S target-utils ${INSTALL_PREFIX}
	cmake --build _build/targetutils -j4 --target install

.PHONY: tdi
tdi: targetsys targetutils
	cmake -B _build/tdi -S tdi ${INSTALL_PREFIX}
	cmake --build _build/tdi -j4 --target install

.PHONY: clean
clean:
	rm -fr _build _install
