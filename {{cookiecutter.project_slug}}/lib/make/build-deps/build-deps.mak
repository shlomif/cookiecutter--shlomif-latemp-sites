MODULES_LIST = bin/required-modules.yml

BIN = ./bin/gen-build-deps

STAMP = lib/make/build-deps/build-deps.stamp

all: $(STAMP)

$(STAMP): $(BIN) $(MODULES_LIST)
	perl $(BIN) -o $@ --modules-conf $(MODULES_LIST)

clean:
	rm -f $(STAMP)
