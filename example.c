#define NULL 0

enum accept {
    INVALID, RNA, DNA, PROTEIN
};

struct state {
    enum accept accept;
    struct state* transition[26];
};

static struct state state_0;
static struct state state_1;
static struct state state_2;
static struct state state_3;

// Initial DNA accepting state
static struct state state_0 = {
    .accept = DNA,
    .transition = {
        &state_0,   // A
        NULL,       // B
        NULL,       // C
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
    }
};


