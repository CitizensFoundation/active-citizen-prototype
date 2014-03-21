In this directory (<tt>/examples</tt>) are several examples of how to use the library.
This file serves as an index, which can be used to find an example for a specific function.

===  function_optimization.rb
- ruby function_optimization.rb hill
  * Description: Function optimization example in many dimensions, hill climbing.
  * Uses: FloatListGenotype, TournamentSelection, UniformCrossover, ListMutator
 
- ruby function_optimization.rb twopeak
  * Description: Function optimization example in 1 dimension, avoiding a local maximum.
  * Uses: FloatListGenotype (single float), NullCrossover, GABenchmark

- ruby function_optimization.rb sombrero
  * Description: Function optimization example in 2 dimensions, avoiding many maxima.
  * Uses: FloatListGenotype, GABenchmark

=== bitstring.rb
- ruby bitstring.rb 512
  * Description: Very simple example that finds the binary representation of 512.
  * Uses: BitStringGenotype
 
- ruby bitstring.rb royalroad
  * Description: Example for convergence with limited feedback from the fitness function.
  * Uses: BitStringGenotype, TruncationSelection, UniformCrossover, ListMutator, cache_fitness, GABenchmark

===  string.rb
- ruby string.rb weasel
  * Description: Simple target string evolver.
  * Uses: StringGenotype, BestOnlySelection, UniformCrossover, ListMutator, GABenchmark
 
- ruby string.rb gridwalk
  * Description: Example of using strings of symbols other than chars to evolve a route through a grid.
  * Uses: StringGenotype, TournamentSelection, evolve_until

=== tsp.rb
- ruby tsp.rb
  * Description: Travelling salesperson problem.
  * Uses: PermutationGenotype, PCross, PMutateN, evolve_until, TournamentSelection,
  *       EdgeRecombinationCrossover, InversionMutator ,InsertionMutator, GABenchmark

===  permutation.rb 
- ruby permutation.rb
  * Description: send+more=money problem with PermutationGenotype.
  * Uses: PermutationGenotype

===  coevolution.rb 
- ruby coevolution.rb simple
  * Description: Simple co-evolutionary example. Evolves a two-element array to be [large,small]
  * Uses: GladiatorialSelection, FloatListGenotype, UniformCrossover, ListMutator

- ruby coevolution.rb sunburn
  * Description: More elaborate example of co-evolution. Evolves weapon systems on space ships (like Ashlock (2004), ch.4).
  * Uses: GladiatorialSelection, StringGenotype, custom mutation/crossover, UniformCrossover

- ruby coevolution.rb prisoner
  * Description: Iterated prisoner's dilemma.
  * Uses: CoTournamentSelection

===  tree.rb 
- ruby tree.rb cos
  * Description: Example for TreeGenotype/GP. Evolves a polynomial that approximates cos(x).
  * Uses: TreeGenotype, ...

- ruby tree.rb pors [n=31]
  * Description: Plus One Recall Store example. Generate a number n using a minimal # of +,1,STO,RCL operations.
  * Uses: TreeGenotype, passing proc{}'s to node values at evaluation, custom unary operators.

- ruby tree.rb porsx [n=31]
  * Description: Same idea as PORS, but generate a tree that evaluates to n*T where T can only be recalled once.

- ruby tree.rb xor
  * Description: Finds the smallest tree for A XOR B using |,&,!.

- ruby tree.rb bloat
  * Description: Just grows large trees.

===  matrix.rb 
- ruby matrix.rb royalmatrix
  * Description: Like bitstring.rb royalroad.
  * Uses: BitMatrixGenotype

- ruby matrix.rb inverse
  * Description: Finds the inverse of a matrix.
  * Uses: FloatMatrixGenotype

===  neural.rb 
- ruby neural.rb
  * Description: Finds a neural network for the XOR function.
  * Uses: NeuralNetworkGenotype


