SHELL := bash

test ?= test
o ?=

BPAN_CMDS := $(shell bpan cmds -q | grep -v test)

default:
	@printf '%s\n' $(BPAN_CMDS)

.PHONY: test
test:
	prove -v $(test)

$(BPAN_CMDS):
	bpan $@ $o
