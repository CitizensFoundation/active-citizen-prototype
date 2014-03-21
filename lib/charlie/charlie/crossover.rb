# This file contains some generic crossovers and functions to generate crossovers

# Just returns the two parents.
module NullCrossover
  def cross(parent1,parent2)
    [parent1.dup,parent2.dup]
  end
end



# Turns a two-children crossover module into a single-child crossover module.
# Usage: use SingleChild(UniformCrossover)
def SingleChild(crossover_module)
  Module.new{
    include crossover_module.dup
    def cross(parent1,parent2)
      super(parent1,parent2).at_rand
    end
    self.name= "SingleChild(#{crossover_module})"
  }
end

# Takes crossover c1 with probability p, and crossover c2 with probability 1-p
def PCross(p,c1,c2=NullCrossover)
  raise ArgumentError, "first argument to PCross should be numeric (probability)." unless p.is_a?(Numeric)
  return c1 if c1==c2
  c1_name, c2_name = [c1,c2].map{|c| '_cross_' + c.to_s.gsub(/[^A-Za-z0-9]/,'') }
  Module.new{
    include c1.dup # dup to avoid bugs on use PCross(..,c1) .. use c1
    alias_method c1_name, :cross
    include c2.dup
    alias_method c2_name, :cross

    define_method(:cross) {|*args|
      rand < p ? send(c1_name,*args) : send(c2_name,*args)
    }
    self.name= "PCross(#{p},#{c1},#{c2})"
  }
end

# Variant of PCross for more than 2 crossovers.
# * Pass a hash of Module=>probability pairs. If sum(probability) < 1, NullCrossover will be used for the remaining probability.
# * example: PCrossN(SinglePointCrossover=>0.33,UniformCrossover=>0.33) for NullCrossover/SinglePointCrossover/UniformCrossover all with probability 1/3
def PCrossN(hash)
  tot_p = hash.inject(0){|s,(m,p)| s+p }
  if (tot_p - 1.0).abs > 0.01 # close to 1?
    raise ArgumentError, "PCrossN: sum of probabilities > 1.0" if tot_p > 1.0
    hash[NullCrossover] = (hash[NullCrossover] || 0.0) + (1.0 - tot_p)
  end
  partial_sums = hash.sort_by{|m,p| -p } # max probability first
  s = 0.0
  partial_sums.map!{|m,p| ['_cross_' + m.to_s.gsub(/[^A-Za-z0-9]/,'') , s+=p, m] }

  Module.new{
    partial_sums.each{|name,p,mod|
      include mod.dup
      alias_method name, :cross
    }
    define_method(:cross) {|*args|
      r = rand
      c_name = partial_sums.find{|name,p,mod| p >= r }.first
      send(c_name,*args)
    }
    self.name= "PCrossN(#{hash.inspect})"
  }
end
