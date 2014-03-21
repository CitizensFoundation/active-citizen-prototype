require 't_common'

class TestCrossover < Test::Unit::TestCase
  def test_cross
    $crs_mth.each{|s|
      klass = TestClass(s)
      assert_nothing_raised{ Population.new(klass,10).evolve_silent(10) }
    }
  end

  def test_blend
    klass = FloatListGenotype(100)
    klass.use BlendingCrossover(0.0)
    p = Array.new(2){klass.new}
    p[0].genes.map!{0.0}
    p[1].genes.map!{1.0}
    10.times{
      ch = klass.cross(p[0],p[1])
      assert ch.all?{|c| c.genes.all?{|g| g > 0.0 && g < 1.0 } }
    }
    assert p[0].genes.all?{|g|g==0.0}
    assert p[1].genes.all?{|g|g==1.0}
    klass.use BlendingCrossover(0.0,:line)
    3.times{
      ch = klass.cross(p[0],p[1])
      assert ch.all?{|c| gn = c.genes; gn[0] > 0.0 && gn[0] < 1.0 && gn.all?{|g| g==gn[0] } }
    }
    assert_raises(ArgumentError) { BlendingCrossover(0.0,:foo) }
  end

  def test_singlechild
    $crs_mth.map{|c| SingleChild(c) }.each{|s|
      klass = TestClass(s)
      r = nil
      assert_nothing_raised{ r=Population.new(klass,10).evolve_silent(10) }
      r.each{|e| assert_equal klass.new.size, e.size } # crossovers should preserver size
    }
  end

  def test_pcross
    $crs_mth.map{|c| PCross(0.5,c) }.each{|s|
      klass = TestClass(s)
      assert_nothing_raised{ Population.new(klass,10).evolve_silent(10) }
    }
    $crs_mth.map{|c| PCross(0.5,c,$crs_mth[-2]) }.each{|s|
      klass = TestClass(s)
      assert_nothing_raised{ Population.new(klass,10).evolve_silent(10) }
    }
  end


  def test_pcrossn
    3.times{
    $crs_mth.map{|c| PCrossN(c=>0.5,$crs_mth.at_rand=>0.3) }.each{|s|
      klass = TestClass(s)
      assert_nothing_raised{ Population.new(klass,10).evolve_silent(10) }
    }
    }
    $crs_mth.map{|c| PCrossN(c=>0.9) }.each{|s|
      klass = TestClass(s)
      assert_nothing_raised{ Population.new(klass,10).evolve_silent(10) }
    }
    assert_raises(ArgumentError) {
       PCrossN(UniformCrossover=>0.5,NullCrossover=>0.6) # => 1.1 > 1.0
    }
    s = PCrossN( Hash[*$crs_mth.map{|c| [c,1 / $crs_mth.size ] }.flatten] )
    klass = TestClass(s)
    assert_nothing_raised{ Population.new(klass,10).evolve_silent(10) }
  end
end