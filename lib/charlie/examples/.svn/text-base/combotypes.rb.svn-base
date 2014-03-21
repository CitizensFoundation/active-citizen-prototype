begin
  require '../lib/charlie'
rescue LoadError
  require 'rubygems'
  require 'charlie'
end

begin
  require 'rubygems'
rescue LoadError
  # RubyGems not installed
end

require 'ruby-debug'
SCRIPT_LINES__ = {} 

if ARGV[0].nil?
  puts "Several examples for bit string genotypes."
  puts "Usage: ruby bitstring.rb 512|royalroad"


elsif ARGV[0].downcase.gsub(/[^0-9]/,'') == '512'

puts "Simple test with a bit string. Find the binary representation of 512."
#Debugger.wait_connection = true
#Debugger.start_remote


#class TypeOne < BitStringGenotype(64)
#  use TruncationSelection(0.3), UniformCrossover, ListMutator([:expected_n, 4],:flip)
#end
#
#class TypeTwo < BitStringGenotype(64)
#  use TruncationSelection(0.3), UniformCrossover, ListMutator([:expected_n, 4],:flip)
#end

class Hill10 <  FloatListGenotype(10,(-1..1))  # 10-dimensional simple hill function
  def fitness 
    1 / (1 + genes.inject(0){|s,x|s+x*x})
  end
  def to_s # don't need the precision of genes.inspect
    '(' + genes.map{|x| '%.02f' % x }.join(',') + ')'
  end
  use TournamentSelection(3), UniformCrossover, ListMutator([:expected_n, 3],[:gaussian, 0.2])
end

genotypes = []
genotypes << Hill10
genotypes << TypeOne
genotypes << TypeTwo

class Test < ComboGenotype(genotypes)
  def fitness
#    puts "ComboGenotype.fitness"
     mygenes = @genotypes[0].genes
#    1 + mygenes.enum_slice(8).find_all{|e| e.all?{|x|x==1} }.size # +1 to avoid all fitness 0 for roulette
    1 / (1 + mygenes.inject(0){|s,x|s+x*x})
  end


  use TruncationSelection(0.3), ComboCrossover, ComboMutator()
#  cache_fitness
end

np = NetworkedPopulation.new(Test)
begin
  np.evolve_incremental_block(100000)
end while not np.complete

#Population.new(Test).evolve_on_console(100)

elsif ARGV[0].downcase.gsub(/[^a-z]/,'') == 'royalroad'

puts "The Royal Road problem."
puts "Find a bit string of 64 ones, while only getting a fitness bonus for groups of 8 ones."
puts "Useful as a test for convergence in situations where there is a lack of feedback."


class RoyalRoad <  BitStringGenotype(64)  # Royal Road problem
  def fitness
#    puts "RoyalRoad.fitness"
    1 + genes.enum_slice(8).find_all{|e| e.all?{|x|x==1} }.size # +1 to avoid all fitness 0 for roulette
  end
  use TruncationSelection(0.3), UniformCrossover, ListMutator([:expected_n, 4],:flip)
#  cache_fitness
end

Population.new(RoyalRoad).evolve_on_console(100)

output_file = 'output/bitstring_royalroad.html';

puts "Running benchmark. Takes about 3 minutes on Ruby 1.9. Output in #{output_file}"

puts "Press [Enter] to continue, or Ctrl-C to abort."
STDIN.gets

GABenchmark.benchmark(RoyalRoad,output_file){
  selection TruncationSelection(0.3),
            Elitism(ScaledRouletteSelection),
            Elitism(RouletteSelection),
            BestOnlySelection,
            RouletteSelection

  crossover NullCrossover, 
            SinglePointCrossover,
            UniformCrossover

  mutator   *(1..6).map{|n| ListMutator(:expected_n[n],:flip) }
  mutator << NullMutator
  generations  100
}


end