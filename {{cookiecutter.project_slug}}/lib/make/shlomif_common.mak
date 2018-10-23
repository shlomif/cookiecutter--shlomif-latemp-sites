SHELL = /bin/bash
PERL := perl

COMMON_PREPROC_FLAGS = -I $$HOME/conf/wml/Latemp/lib -I../lib
LATEMP_WML_FLAGS := $(shell latemp-config --wml-flags)

RSYNC = rsync --progress --verbose --rsh=ssh --exclude='*.d' --exclude='**/*.d' --exclude='**/.*.swp'

# WML_LATEMP_PATH="$$(perl -MFile::Spec -e 'print File::Spec->rel2abs(shift)' '$@')" ;
define DEF_WML_PATH
fn="$$PWD/$@" ;
endef

# cp may sometimes fail in parallel builds due to:
# http://unix.stackexchange.com/questions/116280/cannot-create-regular-file-filename-file-exists
#
# cp: cannot create regular file 'dest/vipe/images/get-firefox.png': File exists
#
define COPY
	cp -f $< $@ || true
endef

TEST_ENV =
TEST_TARGETS = Tests/*.t

define TEST
	$(TEST_ENV) $1 $(TEST_TARGETS)
endef

test: ptest

runtest: all
	$(call TEST,runprove)

ptest: all
	$(call TEST,prove)

%.show:
	@echo "$* = $($*)"

spell: all
	./bin/spell-checker-iface
