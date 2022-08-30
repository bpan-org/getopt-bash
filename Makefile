SHELL := bash

test ?= test
o ?=

default:

BPAN_CMDS := $(shell bpan -q cmds | grep -v test)

.PHONY: test
test:
	prove -v $(test)

$(BPAN_CMDS)::
	bpan $@ $o
