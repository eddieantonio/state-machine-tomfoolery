DOT = dot
CREATE = ./create.rb

MAIN = seqtype


all: $(MAIN)

$(MAIN).o: $(MAIN).c states.c


%.pdf: %.dot
	$(DOT) -Tpdf $< > $@

states.c: $(CREATE)
	$(CREATE) > $@

states.dot: $(CREATE)
	$(CREATE) -g > $@

diagram: states.pdf
view: states.pdf
	open $<

clean:
	$(RM) $(MAIN) $(MAIN).o \
		states.c states.dot states.pdf

.PHONY: all clean diagram view
