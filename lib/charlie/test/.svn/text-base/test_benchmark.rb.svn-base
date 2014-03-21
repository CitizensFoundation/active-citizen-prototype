require 't_common'

CDIR = File.dirname(__FILE__)

class BMTest < Test::Unit::TestCase
 def setup
  Dir.mkdir(CDIR+'/output/') rescue nil
  Dir[CDIR+'/output/*'].each{|f| File.unlink f}
 end

 def test_basic_bm
   assert_nothing_raised {
     GABenchmark.benchmark(RoyalRoad,CDIR+'/output/test_benchmark.html'){
       selection TruncationSelection(0.2), Elitism(ScaledRouletteSelection(),1)
       crossover NullCrossover, UniformCrossover
       mutator   ListMutator(:single_point,:flip), ListMutator(:expected_n[4],:flip)
       self.repeat          = 5
       self.generations     = 40
       self.population_size = 10
     }
   }
   assert( File.read(CDIR+'/output/test_benchmark.html').size > 1000, 'Output file not generated.')
 end


 def test_csv
   assert_nothing_raised {
     GABenchmark.benchmark(StringA,nil,CDIR+'/output/test_benchmark.csv'){
       selection TruncationSelection(0.2)
       crossover NullCrossover, Module.new{self.name='default'}
       mutation  ListMutator(:expected_n[1],:replace[*'a'..'d']), NullMutator
     }
   }
   assert( File.readlines(CDIR+'/output/test_benchmark.csv').size == 4, 'Output file not generated.')
 end

 def test_defaults
   assert_nothing_raised {
     r = GABenchmark.benchmark(StringA,nil,nil){
       selection TruncationSelection(0.2), TournamentSelection(3)
       # no crossover, etc specified.
     }
     assert_equal 2,r.size
   }
   assert_nothing_raised {
     r=GABenchmark.benchmark(StringA,nil,nil){
       crossover NullCrossover
     }
     assert_equal 1,r.size
   }
   assert_nothing_raised {
     r=GABenchmark.benchmark(StringA,nil,nil){
     }
     assert_equal 1,r.size
   }
 end


 def test_multiple_stats
   d = nil
   assert_nothing_raised {
     d = GABenchmark.benchmark(StringA,nil,nil){
       track_stats{|b| [0,1] }
       repeat 11
       generations 17
     }
   }
   assert_equal 1,d.size
   assert_equal 11,d[0][-1].size
   assert d.all?{|r| r[-1].all?{|e| e.size==2 } }
 end


 def test_setup_teardown
   d = nil
   s = t = 0 # count setup/teardown calls/args
   assert_nothing_raised {
     d = GABenchmark.benchmark(StringA,nil,nil){
       selection TruncationSelection, TournamentSelection
       setup{ s+=1 }
       teardown{|p| t += p.size }
       population_size 7
       repeat 10
     }
   }
   assert_equal 2, d.size
   assert_equal 10 * 7 * 2,t
   assert_equal 10 * 2, s
 end
end