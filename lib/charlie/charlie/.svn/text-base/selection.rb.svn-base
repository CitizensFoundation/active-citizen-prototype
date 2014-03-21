# Contains the selection methods.


# Random selection. May be useful in benchmarks, but otherwise useless.
module RandomSelection
  def next_generation(population)
#    puts "RandomSelection"
    new_pop = []
    new_pop += yield(population.at_rand,population.at_rand) while new_pop.size < population.size
    new_pop.pop until new_pop.size == population.size
    new_pop
  end
end

# Truncation selection takes the +best+ invididuals with the highest fitness
# and crosses them randomly to replace all the others.
# +best+ can be an float < 1 (fraction of population size), or a number >=1 (number of individuals)
def TruncationSelection(best=0.3)
  Module.new{
    @@best = best
    def next_generation(population)
#      puts "TruncationSelection"
      k = if @@best >= 1  # best is an integer >= 1 -> select this much
            @@best.round
          else             # best is a float < 1 -> select this percentage
            [1,(@@best * population.size).round].max
          end
      n_new = population.size - k
#      puts "TruncationSelection: #{self.object_id} #{@genes}"
#      puts "TruncationSelection population: #{population.object_id} #{@genes}"
#      puts "BEFORE FITNESS #{:fitness}"
#      puts "BEFORE POPULATION #{population[0].class.get_generation}"
#      puts "BEFORE POPULATION #{population[population[0].class.get_generation]}"
#      puts "AFTER FITNESS"      
#      population = population.sort_by(population[population[0].class.get_generation].send(:fitness))
       population = population.sort_by(&:fitness)
#       puts "top score: #{population[population.length-1].fitness}"
#      population.sort {|a,b| a.fitness <=> b.fitness}
#      population.sort_by{|x|x.fitness}
#      population.sort {|a,b| a <=> b}
      
      best = population[-k..-1]
      new_pop = []
      new_pop += yield(best.at_rand,best.at_rand) while new_pop.size < n_new
      new_pop.pop until new_pop.size == n_new
      new_pop + best
    end
    self.name = "TruncationSelection(#{best})"
  }
end

TruncationSelection = TruncationSelection()

# This selection algorithm is basically randomized hill climbing.
BestOnlySelection = TruncationSelection(1)


# Roulette selection without replacement. Probability of individual i being selected is fitness(i) / sum fitness(1..population size)
module RouletteSelection
  def next_generation(population)
#    puts "RouletteSelection"
    partial_sum = []
    sum = 0
    population.each{|e| partial_sum << (sum += e.fitness) }
    
    n = population.size
    new_pop = []
    i = [0,0]
    while new_pop.size < n
      i[0] = i[1]
      until i[0]!=i[1]
        i.map!{ # binary search
          r = rand * sum
          l = 0; u = n-1;
          while l!=u
           m = (l+u)/2
           if partial_sum[m] < r
            l = m+1
           else
            u = m
           end
          end
          l
        }
      end
      new_pop += yield(population[i[0]],population[i[1]])
    end
    new_pop.pop until new_pop.size == population.size
    new_pop
  end
end

# Scaled Roulette selection without replacement.
# Sorts by fitness, scales fitness by the values the given block yields for its index, then applies Roulette selection to the resulting fitness values.
# Default is Rank selection:   {|x| x+1 }
def ScaledRouletteSelection(&block)
 Module.new{
  block = proc{|x|x+1} if block.nil?
  @@block = block
  @@index = nil
  @@index_size = 0 # population size used to generate index

  def next_generation(population)
 
   if @@index_size != population.size # build index, cache for constant population size
     @@index_size = population.size
     index = []
     (0...population.size).map(&@@block).each_with_index{|e,i| index += Array.new(e.round,i)  }
     @@index = index # ruby 1.9 fix, @@index can't be used in block(?) -- TODO:  figure out why
   end
   population = population.sort_by(&:fitness)

   new_pop = []
   index = @@index
   while new_pop.size < population.size
     i1 = index.at_rand
     i2 = index.at_rand
     if i1==i2
       i1,i2 = @@index.at_rand, @@index.at_rand until i1!=i2 # no replacement
     end
     new_pop += yield(population[i1],population[i2])
   end
   new_pop.pop until new_pop.size == population.size
   new_pop
  end

  self.name= "ScaledRouletteSelection[#{(0..3).map(&block).map(&:to_s).join(',')},...]"
 }
end

ScaledRouletteSelection = ScaledRouletteSelection()
RankSelection = ScaledRouletteSelection()

# Generates a selection module with elitism from a normal selection module.
# Elitism is saving the best +elite_n+ individuals each generation, to ensure the best solutions are never lost.
def Elitism(sel_module,elite_n=1)
 Module.new{
  include sel_module.dup
  @@elite_n = elite_n
  def next_generation(population)
#    puts "Elitism" 
    population = population.sort_by(&:fitness)
    best = population[-@@elite_n..-1]
    population = super
    # reset old best elite_n, but don't overwrite better ones
    population[-@@elite_n..-1] = best.zip_with(population[-@@elite_n..-1]){|old,new| [old,new].max }
    population
  end
  self.name= "Elitism(#{sel_module.to_s},#{elite_n})"
 }
end



# Tournament selection
#
# Default: selects the 2 individuals with the highest fitness out of a random population with size group_size
# and replaces the others with offspring of these 2.
#
# Runs the selection for n_times. If n_times == nil (default), it sets it equal to population size / (group_size-2), 
# i.e. about the same number of new individuals as roulette selection etc.
def TournamentSelection(group_size=4,n_times=nil)
  Module::new{
    @@group_size = group_size
    @@n_times    = n_times
    def next_generation(population)
      n_times = @@n_times || (population.size / (@@group_size-2))
      n_times.times{
        population.shuffle!
        ix = (0...@@group_size).sort_by{|i| population[i].fitness }
        p1,p2 = population[ix[-1]],population[ix[-2]]
        nw = []; 
        nw +=  yield(p1,p2) while nw.size < @@group_size-2
        (@@group_size-2).times{|i| population[ix[i]] = nw[i] }
      }
      population
    end
    self.name= "TournamentSelection(#{group_size},#{n_times.inspect})"
  }
end
TournamentSelection = TournamentSelection()


# Co-evolution: Direct competition (gladiatorial) selection. Define a Genotype#fight function to use this
module GladiatorialSelection
  def next_generation(population)
#    puts "GladiatorialSelection" 
    (population.size/2).times{
      ix=[0,0,0,0]
      ix=(0..3).map{population.rand_index} while ix.uniq.size < 4
      ix[0],ix[1] = ix[1],ix[0] unless population[ix[0]].fight(population[ix[1]])  # 0 and 2 hold winners
      ix[2],ix[3] = ix[3],ix[2] unless population[ix[2]].fight(population[ix[3]])
      nw = []; 
      nw +=  yield(population[ix[0]],population[ix[2]]) while nw.size < 2
      population[ix[1]],population[ix[3]] = *nw
    }
    population
  end
end

#  Co-evolution: competition in tournaments selection.
# * Define a fight_points(other) function in your genotype to use this. The function should return [points for self,points for other]
# * Point-proportial selection is used within tournaments. Entire groups are replaced.
# * full_tournament = true calls both fight_points(population[i],population[j]) AND fight_points(population[j],population[i]) instead of only i < j
# Does this n_times. n_times==nil takes population size / group_size , i.e. about the same number of new individuals as roulette selection etc.
def CoTournamentSelection(group_size=4,full_tournament=false,n_times=nil)
  Module::new{
    @@group_size = group_size
    @@full_tournament = full_tournament
    @@n_times    = n_times
    def next_generation(population)
      n_times = @@n_times || (population.size / @@group_size)     #(population.size / (@@group_size-2))
      n_times.times{
        population.shuffle!
        points = Array.new(@@group_size,0.0)
        for i in 0...@@group_size
         for j in 0...@@group_size
          next if j==i || (i > j && !@@full_tournament)
          r = population[i].fight_points(population[j])
          points[i] += r[0]
          points[j] += r[1]
         end
        end
       # points-proportional selection, with replacement b.c. 1 individual with 100% of the points is not implausible.

        partial_sum = []; sum = 0; points.each{|p| partial_sum << (sum += p) }
        partial_sum.map!{|x|x+1} if sum.abs < 1e-10 # sum==0 -> random
        newgroup = [];
        (@@group_size / 2.0).ceil.times{ 
          sel_ix = [0,0].map{ r=rand*sum; partial_sum.find_index{|ps| ps >= r } }
          newgroup += yield(population[sel_ix[0]],population[sel_ix[1]])
        }
        population[0...@@group_size] = newgroup[0...@@group_size]
      }
      population
    end
    self.name= "CoTournamentSelection(#{group_size},#{full_tournament},#{n_times.inspect})"
  }
end
CoTournamentSelection = CoTournamentSelection()
