# Contains the Population class

# The population class represents an array of genotypes.
# Create an instance of this, and call one of the evolve functions to run the genetic algorithm.
class Population < Array
  DEFAULT_MAX_GENS = 100
  DEFAULT_POP_SIZE = 20
  attr_reader :genotype_class

  def initialize(genotype_class,population_size=DEFAULT_POP_SIZE)
    @genotype_class = genotype_class
    replace Array.new(population_size){ genotype_class.new } 
  end

  # yields population and generation number to block each generation, for a maximum of max_generations.
  def evolve_block(max_generations=DEFAULT_MAX_GENS)
    yield self, 0
    (max_generations || DEFAULT_MAX_GENS).times {|generation|
      self.population = @genotype_class.next_generation(self){|*parents|
        ch = [*@genotype_class.cross(*parents)]
        ch.each{|c| c.mutate! }
        ch
      }
      yield self, generation+1
    }
    self
  end

  # Runs the genetic algorithm without any output. Returns the population sorted by fitness (unsorted for co-evolution).
  def evolve_silent(generations=DEFAULT_MAX_GENS)
    evolve_block(generations){}
    sort_by!{|x|x.fitness} rescue nil
    self
  end
 
  # Runs the genetic algorithm with some stats on the console. Returns the population sorted by fitness.
  def evolve_on_console(generations=DEFAULT_MAX_GENS)
    puts "Generation\tBest Fitness\t\tBest Individual"
    evolve_block(generations) {|p,g|
      best = p.max
      puts "#{g}\t\t#{best.fitness}\t\t#{best.to_s}"
    }
    self.population = self.sort_by{|x|x.fitness}
    puts "Finished: Best fitness = #{self[-1].fitness}"
    self
  end
  alias :evolve :evolve_on_console

  # breaks if the block (which is passed the population each "check_every" generations) returns true.
  # returns an array [population, generations needed]. generations needed==nil for no convergence.
  def evolve_until_population(generations=DEFAULT_MAX_GENS,check_every=10)
    tot_gens = nil
    evolve_block(generations) {|p,g|
      if (g % check_every).zero? && yield(p)
        tot_gens = g
        break
      end
    }
    [self, tot_gens]
  end

  # breaks if the block (which is passed the best individual each "check_every" generations) returns true.
  # returns an array [population, generations needed]. generations needed==nil for no convergence.
  def evolve_until_best(generations=DEFAULT_MAX_GENS,check_every=10)
    tot_gens = nil
    evolve_block(generations)  {|p,g|
      if (g % check_every).zero? && yield(p.max)
        tot_gens = g
        break 
      end
    }
    [self, tot_gens]
  end
  alias :evolve_until :evolve_until_best
  alias :best :max

  # backwards compatibility, returns self
  def population; self; end
  # backwards compatibility, replaces population array
  alias :population= :replace


  # Effectively runs Population#evolve_block <tt>n_runs</tt> times.
  # Returns the entire population of all results (<tt>n_runs * population_size</tt> elements)
  def self.evolve_multiple(genotype_class,population_size=DEFAULT_POP_SIZE,
                           n_runs=25,
                           generations=DEFAULT_MAX_GENS)
    r = evolve_multiple_until_population(genotype_class,population_size, n_runs, generations, 10000) {|pop| false }
    r.first
  end

  # Effectively runs Population#evolve_until_best  multiple times.
  # * See Population.evolve_multiple_until_population for arguments
  #
  # Aliased also as Population.evolve_multiple_until.
  def self.evolve_multiple_until_best(*args,&b)
    evolve_multiple_until_population(*args) {|pop| b.call(pop.max) }
  end

  # Runs Population#evolve_until_population  multiple times.
  # * genotype_class,population_size are arguments for Population.new
  # * max_tries is the maximum number of restarts.
  # * Returns [population, generations needed] on success where population is the population of the successful run.
  # * Returns [population_all, nil] on failure, where population_all is the combined population of all runs.
  def self.evolve_multiple_until_population(genotype_class,population_size=DEFAULT_POP_SIZE,
                                            max_tries=25,
                                            generations=DEFAULT_MAX_GENS,check_every=10)
    tot_gens = 0
    all_pop = []
    max_tries.times{
      pop, gens = Population.new(genotype_class,population_size).evolve_until_population(generations,check_every){|p|
        yield(p)
      }
      all_pop  += pop
      tot_gens += gens || generations
      if gens
        return [pop, tot_gens]
      end
    }
    [all_pop, nil]
  end
  class << self;   alias :evolve_multiple_until :evolve_multiple_until_best; end

end


# Uses GP-style evolution (i.e. crossover OR mutation instead of crossover AND mutation) with a selection method.
# * Works by discarding and replacing the block given to next_generation in Population#evolve_block
# * Is not mandatory for GP, and can just as easily be used for GA or not used in GP.
# * Bit of a strange place to do this, but works nicely with the benchmarking
def GP(sel_module,crossover_probability=0.75)
 ng_name = sel_module.to_s.gsub(/[^A-Za-z0-9]/,'_')
 Module.new{
  include sel_module.dup
  alias_method ng_name, :next_generation
  define_method(:next_generation){|population|
    send(ng_name,population){|*parents|
      if rand < crossover_probability
        [*parents[0].class.cross(*parents)]
      else
        parents.map{|c| c.mutate }
      end
    }
  }
  self.name= "GP(#{sel_module.to_s},#{crossover_probability})"
 }
end


