begin
  require '../lib/charlie'
rescue LoadError
  require 'rubygems'
  require 'charlie'
end


if ARGV[0].nil?
  puts "Several examples for string genotypes."
  puts "Usage: ruby string.rb weasel|gridwalk"




elsif ARGV[0].downcase.gsub(/[^a-z]/,'') == 'weasel'




STR = 'methinks it is like a weasel'
Schars = ('a'..'z').to_a << ' '

puts "A version of the weasel program. Fitness is # of characters that match '#{STR}'."
puts "Useful as a simple test for convergence speed."


class Weasel <  StringGenotype(STR.size,Schars)
  def fitness
    genes.zip(STR.chars).find_all{|a,b|a==b}.size
  end

  def to_s
    genes.join.inspect
  end
  use BestOnlySelection, UniformCrossover, ListMutator(:single_point,:replace[*Schars])
end

Population.new(Weasel).evolve_on_console(200)


output_file = 'output/string_weasel.html'

puts "Running benchmark. Takes about a minute on Ruby 1.9. Output in #{output_file}"
puts "Press [Enter] to continue, or Ctrl-C to abort."
STDIN.gets

GABenchmark.benchmark(Weasel,output_file){
  selection TruncationSelection(0.2), BestOnlySelection, Elitism(ScaledRouletteSelection)
  crossover NullCrossover, SinglePointCrossover, UniformCrossover
  mutator   *(1..4).map{|n| ListMutator(:n_point[n],:replace[*Schars]) }
  generations  100
}





elsif ARGV[0].downcase.gsub(/[^a-z]/,'') == 'gridwalk'






puts "This example tries to find a tour through a grid, in such a way that each square is visited only once."
puts "Often needs to restart multiple times, each time getting stuck in a local maximum, before finding the full solution."

DIRS = [[-1,0],[1,0],[0,-1],[0,1]]
class Walk <  StringGenotype(25,DIRS)  # Walk with steps in 4 directions

  def fitness 
    grid = Array.new(5){Array.new(5)}
    x,y=0,0
    genes.each{|dx,dy|
      grid[x][y] = :visited
      nx,ny = x+dx,y+dy
      x,y=nx,ny if (0..4)===nx && (0..4)===ny && grid[nx][ny].nil? # on grid and haven't been there before
    }
    grid[x][y] = :visited
    grid.flatten.compact.size
  end
  use TournamentSelection(4)
end

# multiple runs of 100 generations until a solution is found. This is better for problems that get stuck in local maxima a lot
pop = gen = nil
loop{
  pop, gen = Population.new(Walk,20).evolve_until(100){|b| b.fitness == 25 } 
  break if gen
  puts "Did not converge in 100 generations, length = #{pop.max.fitness}/25"
}
puts 'Found walk of length 25:', pop[-1].genes.inspect

puts "Second try, no output but shorter code."
pop, gens = Population.evolve_multiple_until(Walk,20,1000){|b| b.fitness == 25 } 

puts "Found walk of length 25 in #{gens} generations:", pop.best.genes.inspect


end
