RSYNC = rsync --progress --verbose --rsh=ssh --exclude='*.d' --exclude='**/*.d' --exclude='**/.*.swp'

# cp may sometimes fail in parallel builds due to:
# http://unix.stackexchange.com/questions/116280/cannot-create-regular-file-filename-file-exists
#
# cp: cannot create regular file 'dest/vipe/images/get-firefox.png': File exists
#
define COPY
	cp -f $< $@ || true
endef

test: ptest

runtest: all
	runprove Tests/*.t

ptest: all
	prove Tests/*.t

%.show:
	@echo "$* = $($*)"

spell: all
	./bin/spell-checker-iface

