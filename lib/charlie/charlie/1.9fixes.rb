#1.9 versions of some functions, to avoid bug #16493. 
#TODO: remove on bugfix/1.9.1
#Bug fixed by now, really should update


def Elitism(sel_module,elite_n=1) # :nodoc:
 ng_name = sel_module.to_s.gsub(/[^A-Za-z0-9]/,'_')
 Module.new{
  include sel_module
  alias_method ng_name, :next_generation
  @@elite_n = elite_n
  define_method :next_generation, ->(population,&block){
    population = population.sort_by(&:fitness)
    best = population[-@@elite_n..-1]
    population = send(ng_name,population,&block)
    # reset old best elite_n, but don't overwrite better ones
    population[-@@elite_n..-1] = best.zip_with(population[-@@elite_n..-1]){|old,new| [old,new].max }
    population
  }
  self.name= "Elitism(#{sel_module.to_s},#{elite_n})"
 }
end


def SingleChild(crossover_module) # :nodoc:
  crs_name =  '_cross_' + crossover_module.to_s.gsub(/[^A-Za-z0-9]/,'')
  Module.new{
    include crossover_module
    alias_method crs_name, :cross

    define_method(:cross){|*args| send(crs_name,*args).at_rand }
    self.name= "SingleChild(#{crossover_module})"
  }
end

module Enumerable
  #undef_method :sum
  #def sum # faster than both r=0; each; r and {|a,b|a+b}
  #  inject(0,:+)
  #end

  undef_method :zip_with
  def zip_with(a2) # avoid Enumerable#zip in 1.9
    r=[]; each_with_index{|e,i| r << yield(e,a2[i]) }; r
  end
end
