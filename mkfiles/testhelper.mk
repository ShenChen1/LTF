export TESTHELPER_SRCDIR ?= $(TESTROOT)/src/testhelper/
export TESTHELPER ?= $(TESTROOT)/bin/cmds/testhelper
export TESTHELPERD ?= $(TESTHELPER_SRCDIR)/testhelperd
$(shell ln -sf $(TESTHELPER_SRCDIR)/testhelper.py $(TESTHELPER))