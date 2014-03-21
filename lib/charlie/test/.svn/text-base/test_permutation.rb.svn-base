require 't_common'

N=10

class PermutationTest < PermutationGenotype(N)
  def fitness
    (0...N).zip_with(genes){|a,b| a==b ? 1 : 0}.sum
  end
end

class PermutationTestERO < PermutationTest
  use EdgeRecombinationCrossover
  use PMutate(0.5,TranspositionMutator)
end

class PermutationTestInvert < PermutationTest
  use InversionMutator, RandomSelection
end

class PermutationTestRotate < PermutationTest
  use RotationMutator, NullCrossover
end
class PermutationTestInsert < PermutationTest
  use InsertionMutator, NullCrossover
end

class PermutationTestPMX < PermutationTest
  use InsertionMutator, PartiallyMappedCrossover, RandomSelection
end



class PermTests < Test::Unit::TestCase
  def test_evolve
    p=nil
    assert_nothing_raised{
      p=Population.new(PermutationTest,20).evolve_silent(20)
    }
    p.each{|s| assert_equal s.genes.sort, (0...N).to_a }
  end


  def test_edge_recombination
    p=nil
    assert_nothing_raised{
      p=Population.new(PermutationTestERO,20).evolve_silent(20)
    }
    p.each{|s| assert_equal s.genes.sort, (0...N).to_a }
  end

  def test_edge_recombination_rand # test if permutation doesn't just stay preserved because of fitness
    p=nil
    assert_nothing_raised{
      klass = Class.new(PermutationTestPMX){ use  } 
      p=Population.new(klass,20).evolve_silent(20)
    }
    p.each{|s| assert_equal s.genes.sort, (0...N).to_a }
  end

  def test_pmx
    p=nil
    assert_nothing_raised{
      p=Population.new(PermutationTestERO,20).evolve_silent(20)
    }
    p.each{|s| assert_equal s.genes.sort, (0...N).to_a }
  end

  def test_inversion_mutator # test if inversion mutator works
    p=nil
    assert_nothing_raised{
      p=Population.new(PermutationTestInvert,20).evolve_silent(20)
    }
    p.each{|s| assert_equal s.genes.sort, (0...N).to_a }
  end

  def test_rotation_mutator # test if rotation mutator works
    p=nil
    assert_nothing_raised{
      p=Population.new(PermutationTestRotate,20).evolve_silent(20)
    }
    p.each{|s|  assert_equal s.genes.sort, (0...N).to_a }
  end

  def test_insertion_mutator # test if insertion mutator works
    p=nil
    assert_nothing_raised{
      p=Population.new(PermutationTestInsert,20).evolve_silent(20)
    }
    p.each{|s|  assert_equal s.genes.sort, (0...N).to_a }
  end
end
