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

.PHONY: cjson
cjson:
	cmake -B ${BUILD_DIR}/cjson \
	    -S ${SOURCE_DIR}/cJSON \
	    -DBUILD_SHARED_AND_STATIC_LIBS=ON \
	    -DENABLE_CJSON_TEST=OFF \
	    ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/cjson --target install

.PHONY: judy
judy: targetsys
	cmake -B ${BUILD_DIR}/judy -S ${SOURCE_DIR}/judy ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/judy -j4 --target install

.PHONY: googletest
googletest:
	cmake -B ${BUILD_DIR}/googletest \
	    -S ${SOURCE_DIR}/googletest \
	    ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/googletest -j4 --target install

.PHONY: targetsys
targetsys: zlog
	cmake -B ${BUILD_DIR}/targetsys \
	    -S ${SOURCE_DIR}/target-syslibs \
	    ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/targetsys --target install

.PHONY: targetutils
targetutils: targetsys cjson judy tommyds
	cmake -B ${BUILD_DIR}/targetutils \
	    -S ${SOURCE_DIR}/target-utils \
	    ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/targetutils -j4 --target install

.PHONY: tdi
tdi: targetsys targetutils # (cjson)
	cmake -B ${BUILD_DIR}/tdi -S ${SOURCE_DIR}/tdi ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/tdi -j4 --target install

.PHONY: tommyds
tommyds:
	cmake -B ${BUILD_DIR}/tommyds -S ${SOURCE_DIR}/tommyds ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/tommyds -j4 --target install

.PHONY: zlog
zlog:
	cmake -B ${BUILD_DIR}/zlog -S ${SOURCE_DIR}/zlog ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/zlog --target install
