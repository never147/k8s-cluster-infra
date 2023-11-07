all: clean diagram.png README.pdf export

%.pdf: %.md
	pandoc $< -o $@

%.png: %.dot
	dot -Tpng $< >$@

export:
	zip export.zip --exclude=export.zip *

clean:
	rm -f *.png *.pdf export.zip
