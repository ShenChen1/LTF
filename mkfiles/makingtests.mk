SHELL:=/bin/bash

# find the root path
export TESTROOT := $(shell pwd -P | sed -e 's,/LTF/.*,/LTF,')

# export some useful tools
export TESTANALYZER ?= $(TESTROOT)/analyzers/test-analyzer

# export test config file
export TESTCONFIG ?= testconfig.mk
ifneq ($(shell echo $(TESTCONFIG) | cut -c1),/)
TESTCONFIG:=$(shell echo "$$(pwd)/$(TESTCONFIG)")
endif
ifeq ($(shell test -e $(TESTCONFIG) && echo 0),0)
include $(TESTCONFIG)
endif

# python
export PYTHONDONTWRITEBYTECODE ?= 1

# add new search path
PATH:=$(TESTROOT)/src/envparser:$(PATH)
PATH:=$(TESTROOT)/bin/flags:$(PATH)
PATH:=$(TESTROOT)/bin/cmds:$(PATH)
PATH:=$(TESTROOT)/bin:$(PATH)

.DEFAULT:
	@PATH="$(PATH)" defaultgoal $@
