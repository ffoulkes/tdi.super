# Copyright 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

BUILD_DIR = _build
SOURCE_DIR = packages
INSTALL_DIR = install

INSTALL_PREFIX = -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}

.PHONY: all
all: googletest tdi

.PHONY: clean
clean:
	rm -fr ${BUILD_DIR} ${INSTALL_DIR}

.PHONY: googletest
googletest:
	cmake -B ${BUILD_DIR}/googletest \
	    -S ${SOURCE_DIR}/googletest \
	    ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/googletest --target install

.PHONY: targetsys
targetsys: zlog
	cmake -B ${BUILD_DIR}/targetsys \
	    -S ${SOURCE_DIR}/target-syslibs \
	    ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/targetsys --target install

.PHONY: targetutils
targetutils: targetsys
	cmake -B ${BUILD_DIR}/targetutils \
	    -S ${SOURCE_DIR}/target-utils \
	    ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/targetutils -j4 --target install

.PHONY: tdi
tdi: targetsys targetutils
	cmake -B ${BUILD_DIR}/tdi -S ${SOURCE_DIR}/tdi ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/tdi -j4 --target install

.PHONY: zlog
zlog:
	cmake -B ${BUILD_DIR}/zlog -S ${SOURCE_DIR}/zlog ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/zlog --target install
