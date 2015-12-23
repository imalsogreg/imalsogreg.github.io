SB=.cabal-sandbox
PROG= $(SB)/bin/webglog

default: install

clean:
	rm -rf dist
	rm -rf _cache
	rm -rf _site

install:
	cabal configure
	cabal install
	$(PROG) build
	cp -r _site/* ../