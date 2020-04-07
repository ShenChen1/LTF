SHELL:=/bin/bash

# find the root path
export TESTROOT := $(shell pwd -P | sed -e 's,/LTF/.*,/LTF,')

# export some useful tools
$(shell ln -sf $(TESTROOT)/src/envparser/envparser.py $(TESTROOT)/analyzers/)
export TESTANALYZER ?= $(TESTROOT)/analyzers/test-analyzer

# python
export PYTHONDONTWRITEBYTECODE ?= 1

# add new search path
PATH:=$(TESTROOT)/bin/flags:$(PATH)
PATH:=$(TESTROOT)/bin/cmds:$(PATH)
PATH:=$(TESTROOT)/bin:$(PATH)

# export setup requirements
export SETUPREQUIREMENTS ?=

# export testsuite file
export TESTSUITE ?= testsuite.mk
ifeq ($(shell test -e $(TESTSUITE) && echo 0),0)
TESTSUITE_TESTS := # To avoid adding cases repeatly
include $(TESTSUITE)
export TESTSUITE_TESTS ?=
export TESTSUITE_PARALLEL ?=
endif

# export test config file
export TESTCONFIG ?= testconfig.mk
ifeq ($(shell test -e $(TESTCONFIG) && echo 0),0)
include $(TESTCONFIG)
endif

.DEFAULT:
	@PATH="$(PATH)" defaultgoal $@
