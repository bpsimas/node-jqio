
PEG=./node_modules/.bin/pegjs

all: gen gen/parser.js

gen/parser.js: src/parser.pegjs
	$(PEG) $< $@ || rm -rf $@

gen:
	mkdir gen

clean:
	rm -rf gen

