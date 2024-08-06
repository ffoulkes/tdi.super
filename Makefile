# Copyright 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

BUILD_DIR = build
SOURCE_DIR = pkgs
INSTALL_DIR = install
PARALLEL = -j4

INSTALL_PREFIX = -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}

.PHONY: all
all: googletest tdi targetutils

.PHONY: clean
clean:
	rm -fr ${BUILD_DIR} ${INSTALL_DIR}

#-----------------------------------------------------------------------

.PHONY: cjson
cjson:
	cmake -B ${BUILD_DIR}/cjson \
	    -S ${SOURCE_DIR}/cJSON \
	    -DBUILD_SHARED_AND_STATIC_LIBS=ON \
	    -DENABLE_CJSON_TEST=OFF \
	    ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/cjson --target install

.PHONY: clean-cjson
clean-cjson:
	rm -fr ${BUILD_DIR}/cjson

#-----------------------------------------------------------------------

.PHONY: judy
judy: targetsys
	cmake -B ${BUILD_DIR}/judy -S ${SOURCE_DIR}/judy ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/judy ${PARALLEL} --target install

.PHONY: clean-judy
clean-judy:
	rm -fr ${BUILD_DIR}/judy

#-----------------------------------------------------------------------

.PHONY: googletest
googletest:
	cmake -B ${BUILD_DIR}/googletest \
	    -S ${SOURCE_DIR}/googletest \
	    ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/googletest ${PARALLEL} --target install

.PHONY: clean-googletest
clean-googletest:
	rm -fr ${BUILD_DIR}/googletest

#-----------------------------------------------------------------------

GPERF_SOURCE_DIR = $(shell realpath ${SOURCE_DIR}/gperftools)
GPERF_BUILD_DIR = $(shell realpath -m ${BUILD_DIR}/gperftools)

.PHONY: gperftools
gperftools:
	cmake -B ${BUILD_DIR}/gperftools\
	    -S ${SOURCE_DIR}/gperftools.build \
	    ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/gperftools ${PARALLEL}

.PHONY: clean-gperftools
clean-gperftools:
	rm -fr ${BUILD_DIR}/gperftools

#-----------------------------------------------------------------------

ifeq (${TCMALLOC},1)
TCMALLOC_OPTION = -DTCMALLOC=ON
TCMALLOC_DEPEND = gperftools
endif

.PHONY: targetsys
targetsys: zlog ${TCMALLOC_DEPEND}
	cmake -B ${BUILD_DIR}/targetsys \
	    -S ${SOURCE_DIR}/targetsys \
	    ${TCMALLOC_OPTION} \
	    ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/targetsys --target install

.PHONY: clean-targetsys
clean-targetsys:
	rm -fr ${BUILD_DIR}/targetsys

#-----------------------------------------------------------------------

.PHONY: targetutils
targetutils: targetsys cjson judy tommyds xxhash
	cmake -B ${BUILD_DIR}/targetutils \
	    -S ${SOURCE_DIR}/targetutils \
	    ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/targetutils ${PARALLEL} --target install

.PHONY: clean-targetutils
clean-targetutils:
	rm -fr ${BUILD_DIR}/targetutils

#-----------------------------------------------------------------------

.PHONY: tdi
tdi: targetsys cjson
	cmake -B ${BUILD_DIR}/tdi -S ${SOURCE_DIR}/tdi ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/tdi ${PARALLEL} --target install

.PHONY: clean-tdi
clean-tdi:
	rm -fr ${BUILD_DIR}/tdi

#-----------------------------------------------------------------------

.PHONY: tommyds
tommyds:
	cmake -B ${BUILD_DIR}/tommyds -S ${SOURCE_DIR}/tommyds ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/tommyds ${PARALLEL} --target install

.PHONY: clean-tommyds
clean-tommyds:
	rm -fr ${BUILD_DIR}/tommyds

#-----------------------------------------------------------------------

.PHONY: xxhash
xxhash:
	cmake -B ${BUILD_DIR}/xxhash -S ${SOURCE_DIR}/xxHash ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/xxhash --target install

.PHONY: clean-xxhash
clean-xxhash:
	rm -fr ${BUILD_DIR}/xxhash

#-----------------------------------------------------------------------

.PHONY: zlog
zlog:
	cmake -B ${BUILD_DIR}/zlog -S ${SOURCE_DIR}/zlog ${INSTALL_PREFIX}
	cmake --build ${BUILD_DIR}/zlog --target install

.PHONY: clean-zlog
clean-zlog:
	rm -fr ${BUILD_DIR}/zlog

#-----------------------------------------------------------------------
