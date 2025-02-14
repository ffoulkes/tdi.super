# tdi.super - Disaggregated version of TDI

This repository is the superproject for a version of p4lang/TDI
that has been disaggregated into its individual components.

## Components

- cJSON
- googletest
- gperftools
- judy
- targetsys
- targetutils
- tdi
- tommyds
- xxHash
- zlog

## Prerequisites

- libedit-dev

## Notes

- I thought I made `judy` a peer of `tommyds` and `xxhash`,
  with soft links in `target-utils` for backward compatibility.
  What happened (and why)?

- The `target-sys` and `target-utils` repositories were renamed
  so they could coexist with the originals. The changes I made
  were extensive.
