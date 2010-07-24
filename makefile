DATE = `date +-%Y-%m-%d`

build: tmp
	ghc --make Main -outputdir tmp -o musgen

run: build
	./musgen
	$(MAKE) ly

open:
	firefox song.midi &
	firefox song.pdf &

tmp:
	mkdir tmp

ly: tmp
	cp song.midi tmp/
	cd tmp && midi2ly song.midi && mv song-midi.ly song.ly
	-cd tmp && lilypond song.ly
	cp tmp/song.pdf ./


clean:
	rm -fr *~ tmp musgen

pack: clean
	cd .. && tar -czf musgen$(DATE).tar.gz musgen --exclude=.svn
