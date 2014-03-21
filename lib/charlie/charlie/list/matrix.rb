


# Generic ancestor for matrix genotypes
def MatrixGenotype(rows,columns=rows)
 Class.new(Genotype) {
  [self,metaclass].each{|c| c.class_eval{
   define_method(:rows)    { rows }
   define_method(:columns) { columns }
   define_method(:size)    { rows * columns }
  }}
  def genes=(g)
    @genes = g.map(&:dup)
  end
  use MatrixUniformCrossover.dup
 }
end

# Genotype for a 2D array of floats.
def FloatMatrixGenotype(rows,columns=rows,range=0..1)
 Class.new(MatrixGenotype(rows,columns)) {
  @@range = range
  def initialize
    self.genes = Array.new(rows){ Array.new(columns){  rand * (@@range.end - @@range.begin) + @@range.begin } }
  end
  def to_s
    @genes.inspect
  end
  use MatrixMutator()
 }
end

# Genotype for a 2D array of bits, for example: connection matrices for graphs
def BitMatrixGenotype(rows,columns=rows)
 Class.new(MatrixGenotype(rows,columns)) {
  def initialize
    self.genes = Array.new(rows){ Array.new(columns){  rand(2) } }
  end
  def to_s
    @genes.map{|r| r.map(&:to_s).join }.join("\n")
  end
  use MatrixMutator(:expected_n,:flip)
 }
end

# Uniform crossover for matrices
module MatrixUniformCrossover
  def cross(parent1,parent2)
    tc1 = []; tc2=[]
    g1 = parent1.genes; g2 = parent2.genes
    g1.each_with_index{|rg1,ri|
      tc1 << (r1=[]); tc2 << (r2=[])
      rg2 = g2[ri];
      rg1.each_with_index{|e,i|
        if rand(2).zero?
          r1 << e; r2 << rg2[i]
        else
          r2 << e; r1 << rg2[i]
        end
      }
    }
    [tc1,tc2].map{|x| from_genes(x) }
  end
end

# The mutation strategies for MatrixMutator
# * :n_point[n=3] : Mutates a single element, n times.     Example: :n_point, :n_point[2]
# * :probability[ p=0.05 ] : Mutates each element with probability p
# * :expected_n[n=3]     : Mutates each element with probability n/genes.size, i.e. such that the expected # of mutations is n
# * :expected_n_per_row[n=3], :expected_n_per_column[n=3] : Likewise
MatrixMutationStrategies = {
  :probability => MMSPRB = Proc.new{|genes,pointmut,p| 
    p ||= 0.05
    genes.map!{|r| r.map!{|e| rand < p ? pointmut.call(e) : e } }
  },
  :expected_n => Proc.new{|genes,pointmut,n|             n ||= 3
    MMSPRB.call(genes,pointmut,n.to_f / (genes.size * genes[0].size))
  },
  :expected_n_per_row => Proc.new{|genes,pointmut,n|     n ||= 3
    MMSPRB.call(genes,pointmut,n.to_f / genes[0].size)
  },
  :expected_n_per_column => Proc.new{|genes,pointmut,n|  n ||= 3
    MMSPRB.call(genes,pointmut,n.to_f / genes.size)
  },
  :n_point => Proc.new{|genes,pointmut,n|
    n ||= 3
    s, r = genes.size, genes.rows;
    n.times{ i,j = rand(s).divmod(r); genes[i][j] = pointmut.call(genes[i][j]) }
  }
}

# Generates a module which can be used as a mutator for matrix-based genotypes like FloatMatrixGenotype and BitMatrixGenotype
# * strategy      should be one of the MatrixMutationStrategies, or a proc
# * point_mutator should be one of the PointMutators (like in ListMutator), or a proc
# * nil is equivalent to proc{} for the point mutator
def MatrixMutator(strategy=:expected_n ,point_mutator=:uniform)
  strat, *strat_args = *strategy
  pm   , *pm_args    = *point_mutator

  pm ||= proc{}

  strat = MatrixMutationStrategies[strat.intern] unless strat.is_a? Proc
  pm    = PointMutators[pm.intern]         unless pm.is_a? Proc
  
  raise ArgumentError,"Invalid mutation strategy" if strat.nil?
  raise ArgumentError,"Invalid point mutator"     if point_mutator.nil?

  if pm_args.empty?
    point_mutator_with_args = pm    
  else
    point_mutator_with_args = proc{|*args| pm.call(*(args+pm_args) ) }
  end

  Module.new{
    define_method(:mutate!) {
      strat.call(@genes,point_mutator_with_args,*strat_args)
      self
    }
    self.name= "MatrixMutator(#{strategy.inspect},#{point_mutator.inspect})"
  }
end
