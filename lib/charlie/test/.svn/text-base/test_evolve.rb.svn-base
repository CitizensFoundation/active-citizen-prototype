require 't_common'

class EvolveTest < Test::Unit::TestCase
  def test_console
    r = Population.new(TestProblem,10).evolve_on_console(10)
    assert_respond_to r, :[]
    assert_respond_to r[-1], :fitness
  end

  def test_silent
    r = Population.new(TestProblem,10).evolve_silent(10)
    assert_respond_to r, :[]
    assert_respond_to r[-1], :fitness
  end

  def test_continue # test if calling evolve twice does not reset the population
    5.times{
     p = Population.new(TestProblem,10)
     best3  = p.evolve_silent(3)[-1].fitness
     best6  = p.evolve_silent(3)[-1].fitness
     assert( best6 >= best3 )
     best36  = p.evolve_silent(30)[-1].fitness
     # Not true for all problems, but in this case the probability of failure is negligible
     assert( best36 > best6, "test_continue failed. Please rerun test to make sure this isn't just extremely bad luck.")
    }
  end

  def test_until_best  # test evolve_until_best
    start = Time.now
    r,g = Population.new(RRTest,10).evolve_until_best(1000_000_000){|b| b.fitness == 0}
    assert_not_nil g
    assert g >= 0 && g < 1000, "test_until_pop failed to converge within 1000 generations"
    assert( (Time.now - start < 1), "test_until failed to converge within 1 second.")
    assert_equal r.max.fitness, 0 # actually converged
    assert_respond_to r, :[]
    assert_respond_to r[-1], :fitness
    # test on failure to converge
    r,g = Population.new(RRTest,10).evolve_until_best(13){|b|  false }
    assert_nil g # did not converge
    assert_respond_to r, :[]
    assert_respond_to r[-1], :fitness
    # alias
    Population.new(RRTest,10).evolve_until{|b| b.fitness == 0}
  end


  def test_until_pop  # test evolve_until_population
    start = Time.now
    r,g = Population.new(RRTest,10).evolve_until_population(100_000_000){|p| p.count{|x| x.fitness == 0 } > 3}
    assert_not_nil g
    assert g >= 0 && g < 1000, "test_until_pop failed to converge within 1000 generations"
    assert( (Time.now - start < 1), "test_until_pop failed to converge within 1 second.")
    assert r.count{|x| x.fitness == 0 } > 3  # actually converged to > 3 clones of best solution
    assert_respond_to r, :[]
    assert_respond_to r[-1], :fitness
    # test on failure to converge
    r,g = Population.new(RRTest,10).evolve_until_population(13){|b|  false }
    assert_nil g # did not converge
    assert_respond_to r, :[]
    assert_respond_to r[-1], :fitness
    # test check_every
    r,g = Population.new(RRTest,10).evolve_until(100,200){|b| b.fitness == 0 }
    assert(g.nil? || g.zero?) # did not converge (except in the gen 0 check), because check_every > max_gens
    r,g = Population.new(RRTest,10).evolve_until(1000,10){|b| b.fitness == 0 }
    assert_not_nil g
    assert( (g % 10).zero?)
  end

  # doesn't really belong here, and should be moved...eventually
  def test_cache
    klass_r  = Class.new(TestProblem){ def fitness; rand; end }
    
    # test cache in random fitness
    e = klass_r.new; 
    assert_not_equal e.fitness, e.fitness
    klass_r.class_eval{ cache_fitness }
    assert_equal e.fitness, e.fitness
    # test performance gain of cache. using tournamentselection(3) and sleep for maximum effect
    klass_nc = Class.new(TestProblem){ def fitness; sleep(0.01); rand; end; use TournamentSelection(3)  }
    klass_c  = Class.new(klass_nc){ cache_fitness }
    3.times { # consistently
     s = Time.now
     Population.new(klass_nc,5).evolve_silent(2)
     t_nc = Time.now - s

     s = Time.now
     Population.new(klass_c,5).evolve_silent(2)
     t_c = Time.now - s
     assert t_c < t_nc # 3x as fast, so fairly safe test
    }
  end


  def test_acc  # test accessors. backward compatibility
    p = Population.new(RRTest,10)
    assert_equal p.max, p.population.max
    assert_equal p.max, p.best
    assert_equal p[6], p.population[6]
  end



 def test_multiple_until_best  # test evolve_multiple_until
    r,g = Population.evolve_multiple_until(RRTest,5,5){false}
    assert_equal 5*5, r.size
    assert_nil g

    r,g = Population.evolve_multiple_until(RRTest,10,500){|b| b.fitness == 0}
    assert_equal 10, r.size
    assert_not_nil g
    assert_equal r.max.fitness, 0 # actually converged
    assert_respond_to r, :[]
    assert_respond_to r[-1], :fitness
  end


 def test_multiple  # test evolve_multiple_until
    r = Population.evolve_multiple(RRTest,5,5)
    assert_equal 5*5, r.size
    assert_respond_to r, :[]
    assert_respond_to r[-1], :fitness
  end

end
