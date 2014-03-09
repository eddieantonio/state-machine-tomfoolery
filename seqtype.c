/*
 * Checks the type of stdin and outputs DNA, Protein, or RNA.
 */

#include <stdio.h>
#include <ctype.h>

#include "states.c"

typedef enum accept seq_t;

seq_t check_type(void);

int main(int argc, char *argv[]) {

	seq_t type;

	type = check_type();

	char *human_name;
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
	int c;
	int norm;

	struct state *current_state = &state_0;

	while ((c = getchar()) != EOF) {
		if (isspace(c)) {
			/* Skip whitespace. */
			continue;
		} else if (!isalpha(c)) {
			/* Invalid if contains any other character. */
			return INVALID;
		}

		/* Turn the char into a number from 0-26. */
		norm = (c &0x1F) - 1;

		current_state = current_state->transition[norm];

		if (current_state == NULL) {
			return INVALID;
		}

	}

	return current_state->accept;

}

/* vi: set ts=8:sw=8:sts=8:noet: */
