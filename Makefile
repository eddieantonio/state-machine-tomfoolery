DOT = dot
CREATE = ./create.rb

# Main task is to view the states.pdf
all: diagram


%.pdf: %.dot
	$(DOT) -Tpdf $< > $@

states.dot: $(CREATE)
	$(CREATE) -g > $@

diagram: states.pdf
view: states.pdf
	open $<

.PHONY: all diagram view
