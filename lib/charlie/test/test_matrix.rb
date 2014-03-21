require 't_common'

class BMatrixTest < BitMatrixGenotype(16,4)
  def fitness
    genes.flatten.count{|b| b==1 }
  end
end

class MatrixTests < Test::Unit::TestCase
  def test_evolve
    p=nil
    assert_nothing_raised{
      p=Population.new(BMatrixTest,20).evolve_silent(20)
    }
    assert p.all?{|s| s.fitness > 32 }, "Insufficient fitness gain, can be extremely bad luck but probably a sign of a bug in the dup code"
    p.each{|s|
     assert s.genes.is_a?(Array) && s.genes.size == 16
     assert s.genes[0].is_a?(Array) && s.genes.all?{|a| a.size==4 }
    }
  end

  def test_listxover
    p=nil
    klass = Class.new(BMatrixTest) {use NPointCrossover(3) }
    assert_nothing_raised{
      p=Population.new(klass,20).evolve_silent(20)
    }
    assert p.all?{|s| s.fitness > 32 }, "Insufficient fitness gain, can be extremely bad luck but probably a sign of a bug in the dup code"
    p.each{|s|
     assert s.genes.is_a?(Array) && s.genes.size == 16
     assert s.genes[0].is_a?(Array) && s.genes.all?{|a| a.size==4 }
    }

  end

end
