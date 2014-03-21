require 't_common'

class TreeTest < TreeGenotype([1,:x,proc{rand}], [:+@], [:+])
  def fitness
    - (eval_genes(:x=>1) - 5).abs
  end
end

class BloatTest < TreeTest
  def fitness
    size
  end
end

$tree_mutators = [
   TreeReplaceMutator,
   TreeReplaceMutator(),
   TreeReplaceMutator(2,:full),
   TreeReplaceMutator(0,:grow),
   TreeReplaceMutator(0..3,:grow),
   TreeReplaceMutator(3..3,:half),
   TreeReplaceMutator(:same,:full),
   TreeReplaceMutator(:same[-1,1],:full),
   TreePruneMutator,
   TreeChopMutator,
   TreeRemoveNodeMutator,
   TreeInsertNodeMutator,
   TreeTerminalMutator,
   TreeNumTerminalMutator,
   TreeNumTerminalMutator(mutate=:gaussian[2.1]),
   TreeNumTerminalMutator{|x|x},
   TreeEvalMutator, NullMutator
 ]

# hard to test, also see examples/tree.rb
class TreeTests < Test::Unit::TestCase
  def test_evolve
    p=nil
    assert_nothing_raised{
      p=Population.new(TreeTest,20).evolve_silent(20)
    }
    p.each{|s| assert s.genes.is_a?(Array) }
  end

  def test_eval
    p=TreeTest.new
    p.genes = [:term,5]
    assert_equal 0, p.fitness
    p.genes = [:+, [:term,:x], [:term,:x]]
    assert_equal  2, p.eval_genes(:x=>1)
    assert_equal  6, p.eval_genes(:x=>3)
    assert_equal( -3, p.fitness)
    p.genes = [:term,:x]
    assert_not_equal p.eval_genes(:x=>proc{rand}), p.eval_genes(:x=>proc{rand})
    assert           p.eval_genes(:x=>proc{rand}).is_a?(Float)
  end

  def test_size
    p=TreeTest.new
    p.genes = [:term,5]
    assert_equal 1, p.size
    p.genes = [:+, [:term,:x], [:term,:x]]
    assert_equal 3, p.size
  end

  def test_bloat
    p=nil
    assert_nothing_raised{
      p=Population.new(BloatTest,20).evolve_silent(50)
    }
    p.each{|s| assert s.genes.is_a?(Array) }
    assert p.max.size > 20, "tree bloat test failed, please rerun to check if this isn't just extremely bad luck"
  end


  def test_init_full
    p=Population.new(TreeGenotype([1],[],[:+],5,:full) )
    p.population.each{|x|
      assert_equal 5, x.depth, "#{x} has a depth < 5"
      x.genes[1..-1].each{|st| assert_equal 4, GPTreeHelper.tree_depth(st), "#{st.inspect} has a depth < 4" }
    }
  end

  def test_init_grow
    p=Population.new(TreeGenotype([1],[],[:+],5,:grow), 100)
    assert  p.population.any?{|x| x.depth < 5 } # with very high probability
    assert !p.population.any?{|x| x.depth > 5 }
    assert  p.population.all?{|x| x.depth > 0 }
  end

  def test_init_half
    p=Population.new(TreeGenotype([1],[],[:+],5,:half), 100)
    assert  p.population.any?{|x| x.depth < 5  } # with very high probability
    assert  p.population.any?{|x| x.depth == 5 } # with very high probability
    assert !p.population.all?{|x| x.depth == 5 } # with very high probability
    assert !p.population.any?{|x| x.depth > 5  }
    assert  p.population.all?{|x| x.depth > 0  }
  end



  def test_mutators
    $tree_mutators.each{|m|
      klass = Class.new(BloatTest) { use m }
      assert_nothing_raised("#{m} failed") { Population.new(klass,10).evolve_silent(10) }
    }
    $tree_mutators.each{|m|
      klass = Class.new(TreeTest) { use PMutate(0.5,m) }
      assert_nothing_raised("#{m} failed") { Population.new(klass,10).evolve_silent(10) }
    }

    all_mut = Hash[*$tree_mutators.map{|x| [x,1.0 / $tree_mutators.size]}.flatten]
    assert_nothing_raised {
      klass = Class.new(TreeTest) { use PMutateN(all_mut) }
      assert_nothing_raised("PMutateN failed") { Population.new(klass,30).evolve_silent(30) }
    }
  end

end
