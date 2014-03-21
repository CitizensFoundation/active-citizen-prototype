begin
  require '../lib/charlie'
rescue LoadError
  require 'rubygems'
  require 'charlie'
end


if ARGV[0].nil?
  puts "Usage: ruby function_optimization.rb hill|twopeak|sombero"


elsif ARGV[0].downcase.gsub(/[^a-z]/,'') == 'hill'



puts "Running a genetic algorithm for maximizing a simple hill function in ten dimensions."
puts

class Hill10 <  FloatListGenotype(10,(-1..1))  # 10-dimensional simple hill function
  def fitness 
    1 / (1 + genes.inject(0){|s,x|s+x*x})
  end
  def to_s # don't need the precision of genes.inspect
    '(' + genes.map{|x| '%.02f' % x }.join(',') + ')'
  end
  use TournamentSelection(3), UniformCrossover, ListMutator([:expected_n, 3],[:gaussian, 0.2])
end

pop = Population.new(Hill10)
pop.evolve_on_console
puts "---------- Setting different mutator ---------- "
Hill10.use ListMutator([:expected_n, 2],[:gaussian, 0.01])
pop_array = pop.evolve_on_console(50)

puts "Best solution: #{pop_array.max.genes.inspect}"


elsif ARGV[0].downcase.gsub(/[^a-z]/,'') == 'twopeak'



output_file = 'output/function_optimization_twopeak.html'
csv_output_file = 'output/function_optimization_twopeak.csv'


puts "Running benchmark for maximizing a function of one variable that has two peaks.\n The left peak is higher than the right peak, but all starting positions are within the right peak.\nThis takes about 90 seconds and produces output in #{output_file} and #{csv_output_file}."

class TwoPeakFunction <  FloatListGenotype(1,(0..1))
  def fitness 
    x = genes.first
    x += 0.5 # all starting position right in the middle of the local maximum hill
    3.1 / (1 + (40*x-4)**2)  + 2.0 / (1+(3*x-2.4)**4)  # two peaks, the left one being higher but very thin.
  end
  use NullCrossover
end

GABenchmark.benchmark(TwoPeakFunction,output_file,csv_output_file) {
  selection BestOnlySelection, TournamentSelection(3), TournamentSelection(4), Elitism(RouletteSelection,1), Elitism(ScaledRouletteSelection(),1), RouletteSelection, ScaledRouletteSelection

  mt = [:probability[0.5],:probability[0.75],:probability[1.0]].map{|s|
         [:uniform[0.1],:uniform[0.2],:uniform[0.4],:uniform[0.8],:uniform[1.6],:gaussian[0.1],:gaussian[0.2],:gaussian[0.4],:gaussian[0.8],:gaussian[1.6]].map{|p| ListMutator(s,p) } }.flatten

  mutator *mt
  generations      10
  population_size  20 
  repeat           100
}




elsif ARGV[0].downcase.gsub(/[^a-z]/,'') == 'sombrero'





output_file = 'output/function_optimization_sombrero.html'

puts "Running benchmark for maximizing a function of two variables with several local maxima.\n The middle peak is the highest, but is surrounded by a chasm.\nThis takes about 50 seconds and produces output in #{output_file}."

class Sombero <  FloatListGenotype(2,(-4*Math::PI..4*Math::PI))
  def fitness 
    x,y=genes
    1 + ( Math.cos(Math.sqrt(x*x+y*y)) / (1+0.1*(x*x+y*y)) )
  end
end

GABenchmark.benchmark(Sombero,output_file) {
  selection BestOnlySelection, TournamentSelection(3), TournamentSelection(4), Elitism(RouletteSelection), Elitism(ScaledRouletteSelection)
  crossover NullCrossover, SinglePointCrossover

  mt = [:n_point[1],:n_point[2]].map{|s|
         [:uniform[ 0.4],:uniform[ 0.8],:uniform[ 1.6],:uniform[ 3.2],:uniform[ 6.4],
          :gaussian[0.4],:gaussian[0.8],:gaussian[1.6],:gaussian[3.2],:gaussian[6.4]].map{|p|      ListMutator(s,p) 
           }
        }.flatten

  mutator *mt
  generations      15
  population_size  10
  repeat           50
}


end






