DOT = dot
CREATE = ./create.rb

MAIN = seqtype


all: $(MAIN)

$(MAIN).o: $(MAIN).c states.c


%.pdf: %.dot
	$(DOT) -Tpdf $< > $@

states.dot: $(CREATE)
	$(CREATE) -g > $@

diagram: states.pdf
view: states.pdf
	open $<

.PHONY: all diagram view
