# Contains genotypes, crossovers and mutators for permutations

# Generates a genotype class which represents a permutation of +elements+
# Includes the PermutationMutator and PermutationCrossover by default
def PermutationGenotype(n,elements=0...n)
 elements = elements.chars if elements.is_a? String # string to array of chars
 elements = elements.to_a
 Class.new(Genotype) {
  define_method(:size)    { n }
  define_method(:elements){ elements }

  def initialize
    @genes = elements.dup.shuffle
  end

  def to_s
    @genes.inspect
  end
  use TranspositionMutator.dup , PCross(0.75,PermutationCrossover)
 }
end

# Transposition mutator for PermutationGenotype. Interchanges two elements and leaves the remaining elements in their original positions.
module TranspositionMutator
  # Transposes two elements
  def mutate!
    i1, i2 = @genes.rand_index,@genes.rand_index 
    @genes[i1],@genes[i2] = @genes[i2], @genes[i1]
    self
  end
end

# Inversion mutator for PermutationGenotype. 
# Takes two random indices, and reverses the elements in between (includes possible wrapping if index2 < index1)
module InversionMutator
  # Inverts parts of the genes
  def mutate!
    i1, i2 = @genes.rand_index,@genes.rand_index 
    if i2 >= i1
      @genes[i1..i2] = @genes[i1..i2].reverse unless i1==i2
    else
      reversed = (@genes[i1..-1] + @genes[0..i2]).reverse
      @genes[i1..-1] = reversed.slice!(0,@genes.size-i1)
      @genes[0..i2] = reversed
    end
    self
  end
end


# Takes a random element of the permutation, and inserts it at a random position.
# * Example: [1 2 3 4 5] to [1 4 2 3 5]
module InsertionMutator
  def mutate!
    from, to = @genes.rand_index, @genes.rand_index
    @genes = if to >= from
      to += 1  # add end of array as possibility 
      (@genes[0...from] + @genes[from+1...to] << @genes[from])  + @genes[to..-1]
    else
      (@genes[0...to] << @genes[from]) + @genes[to...from] + @genes[from+1..-1]
    end
    self
  end
end


#  Rotates the representation of the permutation (i.e. effectively does nothing if it represents a cycle)
# * Example: [1 2 3 4] to [3 4 1 2]
module RotationMutator
  def mutate!
   new_start = @genes.rand_index
   @genes = @genes[new_start..-1] + @genes[0...new_start]
   self
  end
end


# * One point partial preservation crossover for PermutationGenotype
# * Also known as partial recombination crossover (PRX).
# * Child 1 is identical to parent 1 up to the cross point, and contains the remaining elements in the same order as parent 2.
module PermutationCrossover
  def cross(parent1,parent2)
    p1, p2 = parent1.genes, parent2.genes
    cross_pt = rand(p1.size+1)
    st1, st2 =  p1[0...cross_pt],  p2[0...cross_pt]

    [ st1 + (p2 - st1), st2 + (p1 - st2) ].map{|x| from_genes(x) }
  end
end


# Edge recombination operator (http://en.wikipedia.org/wiki/Edge_recombination_operator)
# * Useful in permutations representing a path, e.g. travelling salesperson.
# * Returns a single child.
# * Permutations of 0...n only, i.e. default second parameter to PermutationGenotype
# * Rather slow.
module EdgeRecombinationCrossover
  def cross(parent1,parent2)
    p1, p2 = parent1.genes, parent2.genes
   
    nb = Array.new(parent1.size){[]}
    (p1 + p1[0..1]).each_cons(3){|l,m,r| nb[m] += [l,r] } # build neighbour lists
    (p2 + p2[0..1]).each_cons(3){|l,m,r| nb[m] += [l,r] } # build neighbour lists
    nb.map(&:uniq!)

    n = (rand < 0.5 ? p1.first : p2.first)
    child = [n]
    (nb.size-1).times{
      nb.each{|l| l.delete n unless l==:done }  # remove n from the lists

      if nb[n].empty?  # nb[n] empty, pick random next
        nb[n] = :done
        n = (0...nb.size).find_all{|x| nb[x] != :done }.at_rand # no neighbors left, pick random
      else # pick neighbour with minimal degree, random tie-breaking
        min_deg = nb[n].map{|x| nb[x].size }.min
        next_n = nb[n].find_all{|x| nb[x].size == min_deg }.at_rand # pick random neighbor with min. degree
        nb[n] = :done
        n = next_n
      end 
      child << n  # add new n to path
    }
    
    return from_genes(child)
  end
end

# Two point Partial Preservation Crossover for PermutationGenotype, also known as Partially Mapped Crossover (PMX).
#
# The PMX proceeds by choosing two cut points at random:
#   Parent 1: hkcefd bla igj
#   Parent 2: abcdef ghi jkl
#
# The cut-out section defines a series of swapping operations to be performed on the second parent.
# In the example case, we swap b with g, l with h and a with i and end up with the following offspring:
#   Offspring: igcdef bla jkh
# Performing similar swapping on the first parent gives the other offspring:
#   Offspring: lkcefd ghi abj
#
# Algortithm and description taken from:
#
#   "A New Genetic Algorithm For VPRTW", Kenny Qili Zhu, National University of Singapure,
#   April 13, 2000.
#
# (maybe should be revised with some original documentation)
module PartiallyMappedCrossover
  def cross(parent1,parent2)
    p1, p2 = parent1.genes, parent2.genes
    raise "Chromosomes too small, should be >= 4" if p1.size < 4
    
    # Cut-off points must be after first element and before last.
    cp1 = rand(p1.size-2) + 1
    cp2 = rand(p1.size-2) + 1 while cp2 == cp1 or cp2.nil?
    
    of1, of2 = Array.new(p2), Array.new(p1)
    (cp1..cp2).each do |index|
      of1.swap_element_at_index!(index, p1[index])
      of2.swap_element_at_index!(index, p2[index])
    end
    
    [of1, of2].map{|of| from_genes(of) }
  end
end
