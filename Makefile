# Copyright 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

BUILD_DIR = _build
SOURCE_DIR = pkgs
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

GPERF_SOURCE_DIR = $(shell realpath ${SOURCE_DIR}/gperftools)
GPERF_BUILD_DIR = $(shell realpath -m ${BUILD_DIR}/gperftools)

.PHONY: gperftools
gperftools:
	(cd ${GPERF_SOURCE_DIR}; ./autogen.sh || true)
	rm -fr ${GPERF_BUILD_DIR}
	mkdir -p ${GPERF_BUILD_DIR}/build
	(cd ${GPERF_BUILD_DIR}/build; \
	    ${GPERF_SOURCE_DIR}/configure \
	        --prefix=${GPERF_BUILD_DIR}/install \
		--datarootdir=/tmp/gperftools \
		--disable-shared \
		CXXFLAGS="-O3 -fPIC")
	(cd ${GPERF_BUILD_DIR}/build; make install -j6 V=0)

.PHONY: targetsys
targetsys: gperftools zlog
	cmake -B ${BUILD_DIR}/targetsys \
	    -S ${SOURCE_DIR}/targetsys \
	    ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/targetsys --target install

.PHONY: targetutils
targetutils: targetsys cjson judy tommyds xxhash
	cmake -B ${BUILD_DIR}/targetutils \
	    -S ${SOURCE_DIR}/targetutils \
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

.PHONY: xxhash
xxhash:
	cmake -B ${BUILD_DIR}/xxhash -S ${SOURCE_DIR}/xxHash ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/xxhash --target install

.PHONY: zlog
zlog:
	cmake -B ${BUILD_DIR}/zlog -S ${SOURCE_DIR}/zlog ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/zlog --target install
