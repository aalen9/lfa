# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

TESTS_DIR = ../../..

INFER_OPTIONS = --topl --topl-properties taint.topl --project-root $(TESTS_DIR)
INFERPRINT_OPTIONS = --issues-tests

SOURCES = $(wildcard src/*.erl)

include $(TESTS_DIR)/erlc.make

infer-out/report.json: $(MAKEFILE_LIST)
