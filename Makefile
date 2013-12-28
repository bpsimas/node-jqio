
all: gen gen/parser.js

gen/parser.js: src/parser.pegjs
	pegjs $< $@ || rm -rf $@

gen:
	mkdir gen

clean:
	rm -rf gen

