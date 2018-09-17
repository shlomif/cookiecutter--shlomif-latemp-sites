MODULES_LIST = bin/required-modules.yml

BIN = deps-apps

STAMP = lib/make/build-deps/build-deps.stamp

all: $(STAMP)

$(STAMP): $(MODULES_LIST)
	$(BIN) verify -o $@ --input $(MODULES_LIST)

clean:
	rm -f $(STAMP)
