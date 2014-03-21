# This file defines several different genotype (aka genome, chromosomes) classes.
# Inherit from one of these classes and define a fitness function to use them.


# Genotype of +n+ floats in the range +range+.
# Individuals are initialized as an array of +n+ random numbers in this range.
# Note that mutations may cross range min/max.
def FloatListGenotype(n,range=0..1)
 Class.new(Genotype) {
  @@range = range
  [self,metaclass].each{|c| c.class_eval{ # include both in class and metaclass
   define_method(:size){ n }
  }}
  def initialize(range=nil)
    @@range = range if range
    @genes = Array.new(size){ rand * (@@range.end - @@range.begin) + @@range.begin }
  end
  def to_s
    @genes.inspect
  end
  use ListMutator(), SinglePointCrossover.dup
 }
end


# Genotype of +n+ bits.
# Individuals are initialized as an array of +n+ random bits.
def BitStringGenotype(n)
 Class.new(Genotype) {
  [self,metaclass].each{|c| c.class_eval{ # include both in class and metaclass
   define_method(:size){ n }
  }}
  def initialize
    @genes = Array.new(size){ rand(2) }
  end
  def to_s
#    puts "BitStringGenotype to_s"
    @genes.map(&:to_s).join
  end
  use ListMutator(:expected_n,:flip), SinglePointCrossover.dup
 }
end

# Genotype of +n+ elements (not necessarily chars).
# Individuals are initialized as an array of +n+ elements, each randomly chosen from the +elements+ array.
def StringGenotype(n,elements)
 elements = elements.chars if elements.is_a? String # string to array of chars
 elements = elements.to_a
 Class.new(Genotype) {
  [self,metaclass].each{|c| c.class_eval{ # include both in class and metaclass
   define_method(:size){ n }
   define_method(:elements){ elements }
  }}
  def initialize
    @genes = Array.new(size){ elements.at_rand }
  end
  def to_s
    @genes.map(&:to_s).join
  end
  use ListMutator(:expected_n[2],:replace[*elements]), SinglePointCrossover.dup
 }
end

class TypeOne < BitStringGenotype(64)
  use TruncationSelection(0.3), UniformCrossover, ListMutator([:expected_n, 4],:flip)
end

class TypeTwo < BitStringGenotype(64)
  use TruncationSelection(0.3), UniformCrossover, ListMutator([:expected_n, 4],:flip)
end

def ComboGenotype(genotypes)
 Class.new(Genotype) {
  @@genotypes_names = genotypes
  [self,metaclass].each{|c| c.class_eval{ # include both in class and metaclass
   define_method(:size){ n }
  }}

  def initialize
    @genotypes = []
    @@genotypes_names.each{|g,s|
      if s
        @genotypes << Object.const_get(g.to_s.to_sym).new(s)
      else
        @genotypes << Object.const_get(g.to_s.to_sym).new
      end
    }
  end

  def mutate!
      puts "ComboGenotype.mutate"
  end
  
  def get_genotypes
    @genotypes
  end

  def set_genotype_item(number,genotype_item)
#    puts "set_genotype_item self in #{self.inspect}"
     @genotypes[number]=Marshal::load(Marshal.dump(genotype_item)) 
#    puts "set_genotype_item self ou #{self.inspect}"
  end

  def to_s
    text = "ComboGenotype: #{@genotypes[0].genes}"
#    @genotypes.each{|g|text+=g.inspect+" "}
    text
  end
#  use TruncationSelection(0.3), ComboCrossover, ComboMutator()
  }
end
