#Tree genotype, crossover, mutation etc.

# some general helper functions, which are independant of the operator arrays
module GPTreeHelper
  def dup_tree(t)
    if t.first==:term
      t.clone # avoid inf recursion here
    else
      t.map{|st| st.is_a?(Symbol) ? st : dup_tree(st) }
    end
  end

  def tree_size(t)
    if t.first==:term
      1
    else
      t[1..-1].inject(1){|sum,st| sum + tree_size(st) }
    end
  end

  def tree_depth(t)
    if t.first==:term
      0
    else
      1 + t[1..-1].map{|st| tree_depth(st) }.max
    end
  end

  def all_subtrees(t=@genes)
    if t.first==:term
      [t]
    else
      t[1..-1].map{|st| all_subtrees(st) }.inject{|a,b|a+b} << t
    end
  end
 
  def random_subtree(t=@genes)
    all_subtrees(t).at_rand
  end

  def all_terminals(t=@genes)
    if t.first==:term
      [t]
    else
      t[1..-1].map{|st| all_terminals(st) }.inject{|a,b|a+b}
    end
  end

  def random_terminal(t=@genes)
    all_terminals(t).at_rand
  end

  def eval_tree(tree,values_hash)
    if tree.first == :term
      termval = tree[1]
      if termval.is_a?(Symbol) # look up symbols in the hash
        termval = values_hash[termval]
        termval = termval.call if termval.is_a?(Proc) # and if hash value is a proc, evaluate it
      end
      termval
    else # tree.first is an operator
      eval_tree(tree[1],values_hash).send(tree.first, *tree[2..-1].map{|t| eval_tree(t,values_hash) } )
    end
  end
 
  extend self
end

# Tree genotype, for genetic programming etc.
# * Pass arrays of terminals/unary operators/binary operators to this function to generate a class.
# * terminals can be procs (eval'd on initialization), symbols (replaced by values in calls to eval_genes) or anything else (not changed, so make sure all operators are defined for these)
# * This needs more options. Depth of initial trees, etc. Also needs a better mutator.
def TreeGenotype(terminals, unary_ops, binary_ops, init_depth = 3, init_type = :half)
  unary_ops  = nil if unary_ops.empty?
  Class.new(Genotype) {

    define_method(:unary_ops)  {unary_ops }
    define_method(:binary_ops) {binary_ops}
    define_method(:terminals)  {terminals }
    define_method(:init_depth) {init_depth}
    define_method(:init_type)  {init_type }

    def initialize
      self.genes = generate_random_tree(init_depth,init_type)
    end

    def genes=(g)
      class << g # ensures a genes.dup call is a deep copy
        def dup
          GPTreeHelper.dup_tree(self)
        end
      end
      @genes = g
    end

    def size
      tree_size(@genes)
    end

    def depth
      tree_depth(@genes)
    end


    # Generates a random tree.
    # * type = grow uses generate_random_tree_grow
    # * type = full uses generate_random_tree_full
    # * type = half uses one of them, with 50% probability each.
    def generate_random_tree(depth, type=:half)
      if type==:full || ( type == :half && rand < 0.5 )
        generate_random_tree_full(depth)
      else
        generate_random_tree_grow(depth,true)
      end
    end

    # Generates a random tree of a certain maximum depth.
    # * <tt>no_term=true</tt> makes sure the root node is a function.
    def generate_random_tree_grow(depth,no_term=nil)
      if depth.zero? || (rand(3).zero?  && !no_term)
        e = terminals.at_rand
        [:term, e.is_a?(Proc) ? e.call : e]
      else
        if unary_ops.nil? || rand(2).zero?
          [binary_ops.at_rand,generate_random_tree_grow(depth-1),generate_random_tree_grow(depth-1)]
        else
          [unary_ops.at_rand,generate_random_tree_grow(depth-1)]
        end
       end
    end

    # Generates a random tree, with all terminals at 'depth'.
    def generate_random_tree_full(depth)
      if depth.zero?
        e = terminals.at_rand
        [:term, e.is_a?(Proc) ? e.call : e]
      else
        if unary_ops.nil? || rand(2).zero?
          [binary_ops.at_rand,generate_random_tree_full(depth-1),generate_random_tree_full(depth-1)]
        else
          [unary_ops.at_rand,generate_random_tree_full(depth-1)]
        end
       end
    end

    def eval_genes(terminals_value_hash = {})
      eval_tree(@genes,terminals_value_hash)
    end

    def to_s
      @genes.inspect
    end

    use PCross(0.7,TreeCrossover), PMutate(0.5,TreeReplaceMutator) # TODO: test what options are best -- benchmark show that these are ok for simple settings.

    # make helper functions available at both class and instance level
    include GPTreeHelper
    class << self
      include GPTreeHelper
    end
  }
end

# TreeCrossover does a standard subtree swapping crossover for trees.
module TreeCrossover
  def cross(parent1,parent2)
    child1 = parent1.dup
    child2 = parent2.dup
    c1_st = child1.random_subtree
    c2_st = child1.random_subtree
    c1_copy = dup_tree(c1_st) 
    c1_st.replace dup_tree(c2_st)
    c2_st.replace c1_copy
    [child1,child2]
  end
end

# TreeReplaceMutator replaces a randomly chosen subtree with a new, randomly generated, subtree.
# * depth and type are arguments for TreeGenotype#generate_random_tree
# * depth == [1,2,3,..] or depth==(1..3) uses one of the elements in the range for the depth.
# * depth == :same to use the depth of the replaced subtree.
# * depth == :same[min,max] for depth of the replaced subtree plus a random offset between min and max.
def TreeReplaceMutator(depth=2,type=:half)
  Module.new{
     self.name = "TreeReplaceMutator(#{depth.inspect},#{type.inspect})"
    if depth.is_a? Numeric
      define_method(:mutate!) {
        random_subtree.replace generate_random_tree(depth,type)
        self
      }
    elsif depth==:same || (depth.is_a?(Array) && depth[0]==:same)
      s, dd_min, dd_max = *depth
      possible_deltas = (dd_min||0..dd_max||0).to_a
      define_method(:mutate!) {
        st = random_subtree
        st.replace generate_random_tree([tree_depth(st) + possible_deltas.at_rand,0].max, type)
        self
      }
    elsif depth.respond_to?(:to_a)
      possible_depths = depth.to_a
      define_method(:mutate!) {
        random_subtree.replace generate_random_tree(possible_depths.at_rand,type)
        self
      }
    else
      raise ArgumentError, "invalid option for depth"
    end
  }
end

TreeReplaceMutator = TreeReplaceMutator()
TreePruneMutator   = TreeReplaceMutator(0)

# replace root by one of its children, i.e. TreeRemoveNodeMutator with the root instead of a random node.
module TreeChopMutator
  def mutate!
    return self if genes.first==:term
    genes.replace genes[1..-1].at_rand # replace root with child
    self
  end
end

# replaces a random node by one of its children. does nothing if the randomly chosen node is a terminal.
module TreeRemoveNodeMutator
  def mutate!
    st = random_subtree
    return self if st.first==:term
    st.replace st[1..-1].at_rand
    self
  end
end

# replaces a random node x by a new operator node having x as one of its children. When inserting a binary operator the other node will be a terminal.
module TreeInsertNodeMutator
  def mutate!
    st = random_subtree
    if rand < 0.5 || unary_ops.nil?
      st.replace [binary_ops.at_rand, st.dup, generate_random_tree_full(0)]
    else
      st.replace [unary_ops.at_rand, st.dup]
    end
    self
  end
end

# replaces a random terminal by a new one.
module TreeTerminalMutator
  def mutate!
    random_terminal.replace generate_random_tree(0)
    self
  end
end

# mutates a random numeric terminal using a point mutator (cf. ListMutator) or a block (e.g. {|x| x-rand+0.5}
def TreeNumTerminalMutator(mutate=:uniform[0.1], &b)
 if block_given?
   mutate_proc = b
 else
  mut_name, *mut_arg = mutate
  mut_fn = PointMutators[mut_name]
  mutate_proc = proc{|x| mut_fn.call(x,*mut_arg) }
 end

 Module.new{
  self.name = "TreeNumTerminalMutator(#{mutate.inspect})"
  define_method(:mutate!) {
    numterms = all_terminals.select{|x| x[1].is_a? Numeric }
    unless numterms.empty?
      random_term = numterms.at_rand
      random_term[1] = mutate_proc.call(random_term[1])
    end
    self
  }
 }
end
TreeNumTerminalMutator = TreeNumTerminalMutator()

# Replaces a random subtree by the result of its evaluation. value_hash is passed to eval_tree.
def TreeEvalMutator(value_hash=Hash.new{0})
 Module.new{
  self.name = "TreeEvalMutator(#{value_hash.inspect})"
  define_method(:mutate!) {
    st = random_subtree
    st.replace [:term,eval_tree(st,value_hash)]
    self
  }
 }
end
TreeEvalMutator = TreeEvalMutator()


