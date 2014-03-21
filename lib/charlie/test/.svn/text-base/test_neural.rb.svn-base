require 't_common'

class WTUP < NeuralNetworkGenotype(2,4,1)
  def fitness
    output([rand,rand])[0].abs
  end
  use ListMutator(:n_point[2],:gaussian[0.33])
end

class MatrixTests < Test::Unit::TestCase
  def test_evolve
    p=nil
    assert_nothing_raised{
      p=Population.new(WTUP,20).evolve_silent(50)
    }
    p.each{|s|
     assert s.genes[0..8].map(&:abs).sum > 4 # all > average start - with very high prb
     assert s.genes.is_a?(Array) && s.genes.size == 2*4 + 4 + 4 + 1
    }
  end

end


