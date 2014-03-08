#!/usr/bin/env python
# coding: utf-8

"""
Creates a C file full of states for whatever.
"""


HEADER = r"""
#define NULL 0

enum accept {
    INVALID, RNA, DNA, PROTEIN
};

struct state {
    enum accept accept;
    struct state* transition[26];
};

"""

DNA = frozenset('GTCA')
RNA = frozenset('GTUA')
PROTEIN = frozenset('ACDEFGHIKLMNPQRSTVWYBZ')
U = frozenset('U')
C = frozenset('C')
GTA = frozenset('GTA')
OPROTEIN = PROTEIN - DNA - RNA

STATES = (
    # Initial state.
    ('INVALID', {
        OPROTEIN: 1,
        GTA: 2,
        U: 3,
        C: 4
        }),
    # Protein state 1
    ('PROTEIN', {
        PROTEIN: 1
        }),

    # DNA state 2: "GTA"
    ('DNA', {
        OPROTEIN: 1,
        C: 4,
        U: 3,
        GTA: 2
        }),

    # RNA state 3
    ('RNA', {
        RNA: 3,
        }),

    # DNA state 4: "GTCA"
    ('DNA', {
        DNA: 4,
        OPROTEIN: 1
        })
)
    


def write_declarations(writeln):
    writeln(HEADER)

    # Predeclare all of the fields.
    for number, _state in enumerate(STATES):
        writeln("static struct state state_%d;" % (number))

def write_dot_graph(writeln):
    def state_name(index):
        return 'S%d' % index

    accepting = ' '.join(
        state_name(num) for num, state in enumerate(STATES)
        if state[0] != 'INVALID')

    # Header with formatting options and accepting states.
    writeln(r"""digraph {{

    rankdir=LR;
    node [shape = doublecircle]
        {accepting};
    node [shape = circle];
    """.format(**locals()))

    # Transitions:
    for num, state in enumerate(STATES):
        start = state_name(num)
        accept, transitions = state
        for transition, target in transitions.items():
            target_name = state_name(target)
            
            chars = ''.join(sorted(c for c in transition))
            fmt = "    {start} -> {target_name} [ label = {chars} ];"
            # Ruuuubbbbyyyyyyyy?
            writeln(fmt.format(**locals()))

    writeln("}")

def create_initial_state():
    pass

if __name__ == '__main__':
    def writeln(s):
        print(s)
    write_dot_graph(writeln)

