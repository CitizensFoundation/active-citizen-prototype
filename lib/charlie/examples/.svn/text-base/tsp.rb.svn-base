begin
  require '../lib/charlie'
rescue LoadError
  require 'rubygems'
  require 'charlie'
end

puts "Travelling salesperson problem."

N=7
# NxN cities on a grid
CITIES = (0...N).map{|i| (0...N).map{|j| [i,j] } }.inject{|a,b|a+b}

class TSP < PermutationGenotype(CITIES.size)
  def fitness
    d=0
    (genes + [genes[0]]).each_cons(2){|a,b| 
       a,b=CITIES[a],CITIES[b]
       d += Math.sqrt( (a[0]-b[0])**2 + (a[1]-b[1])**2 ) 
     }
    -d # higher (less negative) fitness is better. This breaks RouletteSelection (use 1.0/d instead), but most other methods can handle this
  end
  use TournamentSelection(4), PCross(0.01,EdgeRecombinationCrossover), PMutateN(InversionMutator=>0.4,InsertionMutator=>0.4)
 
  cache_fitness # benchmark ~ 20% faster, tournament selection 25+% faster
end

puts "Running GA until the optimal solution has been found."
pop, gen = Population.evolve_multiple_until(TSP,30,100,1000,100){|b| puts b.fitness; b.fitness > -(N*N+1) }
puts "Fitness: #{pop.max.fitness}"
puts "Generations needed: #{gen.inspect}"
p pop.max.genes.map{|a| CITIES[a]}
puts Marshal.dump(pop)

puts "Running benchmark. Output in output/tsp.html. Takes about 50 minutes on Ruby 1.9."
puts "Press [Enter] to continue, or Ctrl-C to abort."
STDIN.gets

GABenchmark.benchmark(TSP,'output/tsp.html') {
  selection TruncationSelection(1), Elitism(ScaledRouletteSelection), TournamentSelection(4)
  crossover EdgeRecombinationCrossover, PermutationCrossover,
            PCross(0.5,EdgeRecombinationCrossover,PermutationCrossover),
            PCross(0.01,EdgeRecombinationCrossover), NullCrossover, PartiallyMappedCrossover 

  mutator   TranspositionMutator, InversionMutator, InsertionMutator,
            PMutateN(InversionMutator=>0.4,InsertionMutator=>0.4),
            PMutateN(InversionMutator=>0.4,InsertionMutator=>0.4,RotationMutator=>0.2)

  generations      400
  repeat           8
  population_size  20
}

