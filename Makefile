PREFIX=inst

LIBAV_VERSION=2.5.4.4
VOSK_MODEL_VER=en-us-0.15

OUT=\
    ennuicastr.js ennuicastr.min.js \
    protocol.min.js sw.js \
    awp/ennuicastr-awp.js awp/ennuicastr-worker.js \
    hotkeys.min.js

TEST=\
    ennuicastr-test.js ennuicastr-test.min.js \
    awp/ennuicastr-awp-test.js awp/ennuicastr-worker-test.js

LIBS=\
    libs/NoSleep.min.js libs/web-streams-ponyfill.js libs/jquery.min.js \
    libs/ennuiboard.min.js libs/localforage.min.js \
    libs/vosk-model-small-$(VOSK_MODEL_VER).tar.gz

EXTRA=\
    index.html ennuicastr2.css protocol.js images/no-echo-white.svg \
    libav/libav-$(LIBAV_VERSION)-ennuicastr.js \
    libav/libav-$(LIBAV_VERSION)-ennuicastr.asm.js \
    libav/libav-$(LIBAV_VERSION)-ennuicastr.wasm.js \
    libav/libav-$(LIBAV_VERSION)-ennuicastr.wasm.wasm \
    libs/vad/vad-m.js libs/vad/vad-m.wasm.js libs/vad/vad-m.wasm.wasm \
    libs/vosk.js libs/lib-jitsi-meet.6542.js

all: $(OUT) $(LIBS)

test: $(TEST) $(LIBS)

ennuicastr.js: src/*.ts node_modules/.bin/browserify
	./src/build.js > $@.tmp
	mv $@.tmp $@

ennuicastr.min.js: src/*.ts node_modules/.bin/browserify
	./src/build.js -m > $@.tmp
	mv $@.tmp $@

ennuicastr-test.js: src/*.ts node_modules/.bin/browserify
	./src/build.js > $@

ennuicastr-test.min.js: src/*.ts node_modules/.bin/browserify
	./src/build.js -m > $@

sw.js: src/sw.ts node_modules/.bin/browserify
	./node_modules/.bin/tsc --lib es2015,dom $< --outFile $@

awp/ennuicastr-awp.js: awp/ennuicastr-awp.ts node_modules/.bin/tsc
	./node_modules/.bin/tsc -t es2015 --lib es2017,dom $<

awp/ennuicastr-awp-test.js: awp/ennuicastr-awp.ts node_modules/.bin/tsc
	./node_modules/.bin/tsc -t es2015 --lib es2017,dom $< --outFile $@

awp/ennuicastr-worker.js: awp/ennuicastr-worker.ts node_modules/.bin/tsc
	./node_modules/.bin/tsc --lib es2017,webworker $<

awp/ennuicastr-worker-test.js: awp/ennuicastr-worker.ts node_modules/.bin/tsc
	./node_modules/.bin/tsc --lib es2017,webworker $< --outFile $@

protocol.min.js: protocol.js node_modules/.bin/minify
	./node_modules/.bin/minify --js < $< | cat src/license.js - > $@

hotkeys.min.js: hotkeys.js node_modules/.bin/minify
	./node_modules/.bin/minify --js < $< | cat src/license.js - > $@

node_modules/.bin/browserify:
	npm install

node_modules/.bin/minify: node_modules/.bin/browserify

node_modules/.bin/tsc: node_modules/.bin/browserify

libs/NoSleep.min.js: node_modules/.bin/browserify
	cp node_modules/nosleep.js/dist/NoSleep.min.js $@

libs/web-streams-ponyfill.js: node_modules/.bin/browserify
	cp node_modules/web-streams-polyfill/dist/ponyfill.js $@

libs/jquery.min.js: node_modules/.bin/browserify
	cp node_modules/jquery/dist/jquery.min.js $@

libs/ennuiboard.min.js: node_modules/.bin/browserify
	cp node_modules/ennuiboard/ennuiboard.min.js $@

libs/vosk-model-small-$(VOSK_MODEL_VER).tar.gz:
	curl -L http://alphacephei.com/vosk/models/vosk-model-small-$(VOSK_MODEL_VER).zip -o libs/vosk-model-small-$(VOSK_MODEL_VER).zip
	cd libs/; \
		unzip vosk-model-small-$(VOSK_MODEL_VER).zip; \
		mv vosk-model-small-$(VOSK_MODEL_VER) model; \
		tar zcf vosk-model-small-$(VOSK_MODEL_VER).tar.gz model/; \
		rm -rf model

libs/localforage.min.js: node_modules/.bin/browserify
	cp node_modules/localforage/dist/localforage.min.js $@

install:
	mkdir -p $(PREFIX)/images $(PREFIX)/libs/vad $(PREFIX)/awp $(PREFIX)/libav
	for i in $(OUT) $(LIBS) $(EXTRA); do \
		install -C -m 0622 $$i $(PREFIX)/$$i; \
        done
	for i in $(TEST); do \
		install -C -m 0622 $$i $(PREFIX)/$$i || true; \
        done
	cp -a fa $(PREFIX)/

clean:
	rm -f $(OUT) $(TEST) $(LIBS)
