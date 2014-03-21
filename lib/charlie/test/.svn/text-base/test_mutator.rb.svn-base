require 't_common'

module Enumerable
 def uniq_by
   h = {}; inject([]) {|a,x| h[yield(x)] ||= a << x}
 end
end

ms = [:single_point,[:n_point],:n_point[3],:expected_n[],:expected_n[1],:probability,:probability[0.3]]
pm = [:gaussian,:gaussian[0.25],:uniform,:uniform[0.1],:flip,:replace[0.2,0.1,0.0,-0.1,-0.2]]
$mut_mth = [NullMutator]
ms.each{|m| pm.each{|p| $mut_mth << ListMutator(m,p) } }



class TestMutator < Test::Unit::TestCase
  def test_mutate
    $mut_mth.each{|m|
      klass = TestClass(m)
      assert_nothing_raised("#{m} failed") { Population.new(klass,10).evolve_silent(10) }
    }
  end

  def test_bit
    klass = TestClass(ListMutator(:single_point,:flip),RoyalRoad)
    p = nil
    assert_nothing_raised{ p=Population.new(klass,10).evolve_silent(10) }
    assert p.all?{|s| s.genes.all?{|x| x==0 || x==1 }}
    klass = TestClass(ListMutator(:expected_n[100],:replace[0,1]),RoyalRoad)
    assert_nothing_raised{ p=Population.new(klass,10).evolve_silent(10) }
    assert p.all?{|s| s.genes.all?{|x| x==0 || x==1 }}
  end

  def test_str
    klass = TestClass(ListMutator(:single_point,:replace['a','b']),StringA)
    p = nil
    assert_nothing_raised{ p=Population.new(klass,10).evolve_silent(10) }
    assert p.all?{|s| s.genes.all?{|x| ('a'..'d')===x }}
    
    klass = TestClass(ListMutator(:single_point,:replace['z','x']),StringA)
    assert_nothing_raised{ p=Population.new(klass,10).evolve_silent(10) }
    assert p.all?{|s| s.genes.all?{|x| ['a','b','c','d','x','z'].include? x }}
  end

  def test_pmutate
    klass = TestClass(PMutate(0.5,ListMutator(:single_point,:replace['a','b'])),StringA)
    p = nil
    assert_nothing_raised{ p=Population.new(klass,10).evolve_silent(10) }
    assert p.all?{|s| s.genes.all?{|x| ('a'..'d')===x }}
  end

  def test_pmutaten
    3.times{
    $mut_mth.map{|c| PMutateN(c=>0.5,$mut_mth.at_rand=>0.3) }.each{|s|
      klass = TestClass(s)
      assert_nothing_raised{ Population.new(klass,10).evolve_silent(10) }
    }
    }
    $mut_mth.map{|c| PMutateN(c=>0.9) }.each{|s|
      klass = TestClass(s)
      assert_nothing_raised{ Population.new(klass,10).evolve_silent(10) }
    }
    assert_raises(ArgumentError) {
       PMutateN(ListMutator(:single_point,:uniform)=>0.5,NullMutator=>0.6) # => 1.1 > 1.0
    }
    s = PMutateN( Hash[*$mut_mth.map{|c| [c,1 / $mut_mth.size ] }.flatten] )
    klass = TestClass(s)
    assert_nothing_raised{ Population.new(klass,10).evolve_silent(10) }
  end
end