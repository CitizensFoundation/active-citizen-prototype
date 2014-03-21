

require File.dirname(__FILE__) + '/../lib/charlie' unless Object.const_defined?('Charlie')
require 'test/unit'

$crs_mth = [NullCrossover, SinglePointCrossover, UniformCrossover, NPointCrossover(1), NPointCrossover(2), NPointCrossover(24),BlendingCrossover(0.1,:line),BlendingCrossover(1.3,:cube)]


class TestProblem <  FloatListGenotype(2,0..1)
  def fitness
    genes.map{|x| [x,10].min }.sum
  end
end

def TestClass(mod,klass=TestProblem)
  Class.new(klass){use mod}
end

class RoyalRoad <  BitStringGenotype(64)
  def fitness
    genes.enum_slice(8).find_all{|e| e.all?{|x|x==1} }.size
  end
end

class StringA <  StringGenotype(20,'a'..'d')
  def fitness
    genes.find_all{|c| c=='a'}.size
  end
  use UniformCrossover
end

class RRTest <  BitStringGenotype(8) # easier convergence, fitness 0 at max. for testing evolve_until, etc.
  def fitness 
    genes.enum_slice(2).find_all{|e| e.all?{|x|x==1} }.size - 4
  end
  use ListMutator(:expected_n[1],:flip), TruncationSelection(0.3), UniformCrossover
end

class TestTest < Test::Unit::TestCase
  def test_testclass
    assert_nothing_raised{
     Population.new(TestClass(Module::new),10).evolve_silent(2)
     Population.new(TestClass(UniformCrossover),10).evolve_silent(2)
     Population.new(TestClass(ListMutator(:single_point,:gaussian) ),10).evolve_silent(2)
     Population.new(TestClass(TournamentSelection(4)),10).evolve_silent(2)
    }
  end
end