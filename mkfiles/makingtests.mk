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

# add new search path
ifneq ($(TEST_PATHPREFIX),)
PATH:=$(TEST_PATHPREFIX):$(TESTROOT)/bin:$(PATH)
else
PATH:=$(TESTROOT)/bin:$(PATH)
endif

.DEFAULT:
	@PATH="$(PATH)" defaultgoal $@
