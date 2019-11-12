SHELL:=/bin/bash

export TESTROOT := $(shell pwd -P | sed -e 's,/LTF/.*,/LTF,')

testconfig:
	@defaultgoal-testconfig
