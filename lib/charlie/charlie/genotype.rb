# Contains the base class for genotypes


# Base class. Inherit this if you're starting from scratch
class Genotype
  attr_accessor :genes

  # raises an exception when called
  def fitness
    raise NoMethodError, "You need to define a fitness function in your genotype class!"
  end 
  # raises an exception when called
  def fight(other)
    raise NoMethodError, "You need to define a fight(other) function in your genotype class to use this selection strategy!"
  end 

  class << self

    # For each module passed:
    # Includes the module if it has a mutate! method, and includes it in the metaclass otherwise.
    # Used to include selection/crossover/mutation modules in one line, or just to avoid all the class<<self;include ...;end
    #  class Example < Genotype
    #    use RandomSelection, NullCrossover, NullMutator
    #  end
    def use(*mods)
      mods.each{|mod|
       if mod.instance_methods(true).find { |m| m.to_s == 'mutate!'} # ruby1.8 returns strings, 1.9 symbols  so include? doesn't work
         include mod
       else
         metaclass.class_eval{
           include mod
         }
       end
      }
    end

    # Creates a new instance of your genotype class given its genes.
    def from_genes(g)
#      puts "Genotype from_genes #{g.inspect}"
      r = allocate
      r.genes = g
      r
    end

    # Adds caching to the fitness function. Only call AFTER defining your fitness function.
    # Never clears the cache. This should work most of the time because crossovers/from_genes create new instances.
    def cache_fitness
      alias_method :real_fitness, :fitness
      define_method(:fitness) {
        @fitness_cache ||= send(:real_fitness)
      }
      self
    end
  end
 
  def clear_cache
    @fitness_cache = nil
  end
  # Used by Genotype.cache_fitness. This accessor can be used to clear the cache.
  # Also could be used by niche selection, etc. as a place to change the effective fitness w/o changing the actual selection algorithms.
  attr_accessor :fitness_cache 

  def dup
    self.class.from_genes(genes.dup)
  end

  def mutate
    cp = dup
    cp.mutate!
    cp
  end

  def to_s
    @genes.to_s
  end

  # Defines fight in terms of fight_points (self wins if it has at least as many points as other). Used in co-evolution.
  #def fight(other)
  #  r = fight_points(other)
  #  return r[0]>=r[1]
  #end

  # Defines fight_points in terms of fight (1 point for the winner, 0 for the loser). Used in co-evolution.
  ##def fight_points(other)
  #  fight(other) ? [1,0] : [0,1]
  #end


  include Comparable
  def <=>(b)
    fitness <=> b.fitness
  end
  # Higher default max. population size for the selection
  # .dup on constant modules ensures inherited classes can revert back to this
  use NullCrossover.dup, NullMutator.dup, Elitism(ScaledRouletteSelection(),1)
end