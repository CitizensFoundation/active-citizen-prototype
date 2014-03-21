# Contains the Networked Population class
class NetworkedPopulation < Population
  DEFAULT_MAX_GENS = 100
  DEFAULT_POP_SIZE = 20
  attr_reader :genotype_class, :generation, :complete, :population_size

  def initialize(genotype_class,population_size)
    @generation = 0
    @complete = false
    @population_size = population_size
    super
  end

  def evolve_incremental_block(max_generations,logger=nil)
    @logger=logger
    if @generation<max_generations
      @logger.info("BEFORE")
      @logger.info("Size = #{self.population.length}")
      c = []      
      self.population.each do |individual|
          c << individual.fitness
      end
      c.sort.each do |cc|
        @logger.info("Fitness = #{cc}")
      end
      @logger.info("FAverage Best fitness = #{c.sort[-1]}")
      @logger.info("FAverage Bottom fitness = #{c.sort[0]}")
      self.population = @genotype_class.next_generation(self){|*parents|
        ch = [*@genotype_class.cross(*parents)]
        ch.each{|c| c.mutate! }
        ch
      }
#      @logger.info("AFTER")
#      @logger.info("FAverage Size fitness = #{self.population.length}")
#      c = 0
#      self.population.each do |individual|
#        @logger.info("FAverage for #{c} fitness = #{individual.fitness}")
#        c+=1
#      end
#      @logger.info("FAverage Best fitness = #{self.population[-1].fitness}")
#      @logger.info("FAverage Bottom fitness = #{self.population[0].fitness}")
      @generation = @generation+1
      @logger=nil
    else
      @logger.info("FAverage Finished: Best fitness = #{self.population[-1].fitness}")
      @logger.info("FAverage Finished: Bottom fitness = #{self.population[0].fitness}")
      @complete = true
      @logger=nil
    end
    self
  end
end