require 't_common'

#ObjectSpace.each_object(Module){|m|
#  $sel_mth << m if m.instance_methods.include?('next_generation')
#}
#p $sel_mth
$sel_mth = [RouletteSelection, RandomSelection]

$sel_mth += [TournamentSelection(3),TournamentSelection(4,1),TournamentSelection(8,30),
             TruncationSelection(0.0),TruncationSelection(0.3),TruncationSelection(1), TruncationSelection(6),
             ScaledRouletteSelection(), ScaledRouletteSelection{|i| 2*i+1 }, ScaledRouletteSelection{|i| i<10 ? 1 : i }
            ]
             
$sel_mth = $sel_mth.uniq


class CoEvTest <  FloatListGenotype(2)
  def fight(other)
    rand < 0.5 ? genes[0] >= other.genes[0] :  genes[1] <= other.genes[1]
  end
  def fight_points(other)
    fight(other) ? [1,0] : [0,1]
  end
  use GladiatorialSelection, UniformCrossover, ListMutator(:expected_n[1],:gaussian[0.25])
end



class TestSelection < Test::Unit::TestCase
  def test_selection
    $sel_mth.each{|s|
      klass = TestClass(s)
      assert_nothing_raised{ Population.new(klass,10).evolve_silent(10) }
    }
  end

  def test_elitism
    [0,1,5].each{|k|
    $sel_mth.map{|s| Elitism(s,k)  }.each{|s|
      klass = TestClass(s)
      assert_nothing_raised{ Population.new(klass,10).evolve_silent(10) }
    }
    }
  end

  def test_singlechild
    scc = TestClass(SingleChild(NullCrossover))
    $sel_mth.each{|s|
      klass = TestClass(s,scc)
      assert_nothing_raised{ Population.new(klass,10).evolve_silent(10) }
    }
  end

  def test_coev
    assert_nothing_raised{ Population.new(CoEvTest,21).evolve_silent(10) }
    [[4,false,23],[3,true,nil],[7,false,5],[9,false,nil]].each{|co_arg|
      klass = Class.new(CoEvTest) { use CoTournamentSelection(*co_arg) }
      assert_nothing_raised{ Population.new(klass,co_arg[0]*2+1).evolve_silent(10) }
    }
  end


  def test_gp
    [0,1.0,0.5].each{|k|
    $sel_mth.map{|s| GP(s,k)  }.each{|s|
      klass = TestClass(s)
      assert_nothing_raised{ Population.new(klass,10).evolve_silent(10) }
    }
    }
    klass = TestClass( Module.new{ def cross(*a); raise RuntimeError, "CROSSOVER REACHED"; end } )
    klass.use TournamentSelection
    assert_raises(RuntimeError) { Population.new(klass,10).evolve_silent(10) }
    klass.use GP(TournamentSelection,0.0)
    assert_nothing_raised { Population.new(klass,10).evolve_silent(10) }
  end

end