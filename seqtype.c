/*
 * Checks the type of stdin and outputs DNA, Protein, or RNA.
 */

#include <stdio.h>
#include <ctype.h>
#include <assert.h>

#include "states.c"

typedef enum accept seq_t;

seq_t check_type(void);

int main(int argc, char *argv[]) {
	seq_t type;
	char *human_name;

	type = check_type();

	switch (type) {
		case RNA:
		    human_name = "RNA";
		    break;
		case DNA:
		    human_name = "DNA";
		    break;
		case PROTEIN:
		    human_name = "protein";
		    break;
		default:
		    human_name = "unknown";
	}

	printf("Type input is: %s\n", human_name);

	return 0;
}

/**
 * Returns the type of the sequence. Skips newlines and whitespace.
 */
seq_t check_type(void) {
	int c, index;
	struct state *current_state;
	
	current_state = &state_0;

	while ((c = getchar()) != EOF) {
		if (isspace(c)) {
			/* Skip whitespace. */
			continue;
		} else if (!isalpha(c)) {
			/* Invalid if contains any other character. */
			return INVALID;
		}

		/* Turn the char into a valid index in the transition array. */
		index = (c & 0x1F) - 1;

		assert(index >= 0 && index <= 25);

		/* Fetch the next state. */
		current_state = current_state->transition[index];

		if (current_state == NULL) {
			return INVALID;
		}

	}

	return current_state->accept;

}

/* vi: set ts=8:sw=8:sts=4:noet: */
