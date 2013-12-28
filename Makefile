
all: lib lib/parser.js

lib/parser.js: src/parser.pegjs
	pegjs $< $@ || rm -rf $@

lib:
	mkdir lib

clean:
	rm -rf lib

