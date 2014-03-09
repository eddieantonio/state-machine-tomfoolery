#!/usr/bin/env ruby

#
# Creates a C and Graphviz files of states transitions for a FSM that
# accepts strings of DNA, RNA, and protein base letters.
#

require 'erb'
require 'ostruct'
require 'set'


# Convert a string into a set of all of its elements. I might have stolen this
# from Python.
def frozenset(str)
  str.split('').to_set
end

# The various sets that exist.
DNA = frozenset('GTCA')
RNA = frozenset('GTUA')
PROTEIN = frozenset('ACDEFGHIKLMNPQRSTVWYBZ')
U = frozenset('U')
C = frozenset('C')
GTA = frozenset('GTA')
OPROTEIN = PROTEIN - (DNA | RNA)


State = Struct.new(:accept, :transitions) do
  # This is a bad name for the method but I don't know what to call it.
  def unwrap
    result = {}

    # Populate the hash with each transition.
    transitions.each do |chars, target_num|
      chars.each { |char| result[char] = target_num }
    end

    # Add all missing letters.
    ('A'..'Z').each do |char|
      result[char] = nil unless result.has_key? char
    end

    result.sort_by { |char, _|  char }
  end
end


STATES = [
  # Initial state.
  State.new(:INVALID, {
    OPROTEIN => 1,
    GTA => 2,
    U => 3,
    C => 4
  }),

  # Protein state 1
  State.new(:PROTEIN, {
    PROTEIN => 1
  }),

  # DNA => state 2 => "GTA"
  State.new(:DNA, {
    OPROTEIN => 1,
    C => 4,
    U => 3,
    GTA => 2
  }),

  # RNA state 3
  State.new(:RNA, {
    RNA => 3,
  }),

  # DNA state 4 => "GTCA"
  State.new(:DNA, {
    DNA => 4,
    OPROTEIN => 1
  })
]



def run!
  unless ARGV.member? '-g'
    write_c_file
  else
    write_dot_graph
  end
end



# Prints a Graphviz/Dot graph file.
def write_dot_graph
  def state_name(index)
    "S#{index}"
  end

  # Create a list of accepting state names.
  accepting = []
  STATES.each_with_index do |state, num|
    accepting.push [state_name(num), state] if state.accept != :INVALID
  end

  # Transitions:
  transitions = []
  STATES.each_with_index do |state, num|
    start = state_name(num)

    for transition, target_num in state.transitions
      target = state_name(target_num)
      # Convert the transition set to a nice sorted string of bases.
      chars = transition.to_a.sort.join ''

      transitions.push [start, target, chars]
    end
  end

  # Print the actual template.
  template = load_erb('./states.dot.erb')
  vars = {accepting_states: accepting, transitions: transitions}
  template.run binding_from_hash(vars)
end



# Writes the C header file to stdout.
def write_c_file
  template = load_erb('./states.c.erb')
  template.run binding_from_hash({states: STATES})
end



# Creates a binding suitable for ERB templates from the given hash.
def binding_from_hash(hash)
  # Use this as our binding:
  namespace = OpenStruct.new hash
  namespace.instance_eval { binding }
end

# Returns the ERB template with the given filename.
def load_erb(filename)
  template_file = File.new(filename).read
  ERB.new(template_file, nil, '<>')
end

run! if __FILE__ == $0

