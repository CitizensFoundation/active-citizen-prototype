# Contains some basic mutators and functions on mutators

# Simply returns the non-mutated genes
module NullMutator
  def mutate!; self; end 
end


# Takes mutator m1 with probability p, and mutator m2 with probability 1-p
def PMutate(p,m1,m2=NullMutator)
  raise ArgumentError, "first argument to PMutate should be numeric (probability)." unless p.is_a?(Numeric)
  return m1 if m1==m2
  m1_name, m2_name = [m1,m2].map{|c| '_mutate_' + c.to_s.gsub(/[^A-Za-z0-9]/,'') + '!' }
  Module.new{
    include m1.dup # dup to avoid bugs on use PMutate(..,m1) .. use m1
    alias_method m1_name, :mutate!
    include m2.dup
    alias_method m2_name, :mutate!

    define_method(:mutate!) {
      rand < p ? send(m1_name) : send(m2_name)
    }
    self.name= "PMutate(#{p},#{m1},#{m2})"
  }
end


# Variant of PMutate for more than 2 mutators
# * Pass a hash of Module=>probability pairs. If sum(probability) < 1, NullMutator will be used for the remaining probability.
# * example: PCrossN(SinglePointCrossover=>0.33,UniformCrossover=>0.33) for NullCrossover/SinglePointCrossover/UniformCrossover all with probability 1/3
def PMutateN(hash)
  tot_p = hash.inject(0){|s,(m,p)| s+p }
  if (tot_p - 1.0).abs > 0.01 # close to 1?
    raise ArgumentError, "PMutateN: sum of probabilities > 1.0" if tot_p > 1.0
    hash[NullMutator] = (hash[NullMutator] || 0.0) + (1.0 - tot_p)
  end
  partial_sums = hash.sort_by{|m,p| -p } # max probability first
  s = 0.0
  partial_sums.map!{|m,p| ['_mutate_' + m.to_s.gsub(/[^A-Za-z0-9]/,'') + '!' , s+=p, m] }

  Module.new{
    partial_sums.each{|name,p,mod|
      include mod.dup
      alias_method name, :mutate!
    }
    define_method(:mutate!) {
      r = rand
      send partial_sums.find{|name,p,mod| p >= r }.first
    }
    self.name= "PMutateN(#{hash.inspect})"
  }
end

