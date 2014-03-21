begin
  require '../lib/charlie'
rescue LoadError
  require 'rubygems'
  require 'charlie'
end
require 'pp'

# several examples of genetic programming

if ARGV[0]=='cos'

$size_fac = 0.0
# approximate cos(x) by a polynomial.on [0,3]. usually results in some kind of linear approximation.like 1.3-0.8x
class Cos < TreeGenotype([proc{3*rand-1.5},:x], [:-@], [:+,:*,:-])
  def fitness
   #-(0..10).map{|x| (eval_genes(:x=>0.3*x) - Math.cos(0.3 * x) ).abs }.sum - 0.1*size  # last term used to counter bloat
   # also possible, use infinity norm instead of L1 norm
   #-(0..10).map{|x| (eval_genes(:x=>0.3*x) - Math.cos(0.3 * x) ).abs }.max

   # smaller range [0,1.5] and inf norm give higher order approximations
   -(0..10).map{|x| (eval_genes(:x=>0.1*x) - Math.cos(0.1 * x) ).abs }.max
  end
  use PMutate(0.5,TreeReplaceMutator.dup,TreeNumTerminalMutator.dup)
end

pop = Population.new(Cos)

loop{
 pop.evolve_on_console(500)
 pp pop.best.genes
 puts "q to quit, enter to continue"
 break if $stdin.gets =~ /q/
}



elsif ARGV[0]=='pors'


# plus one recall store, generate the number ARGV[1] || 31 using +, 1 and recall/store operations (as few ops as possible).

class Fixnum
  def sto
    $pors_store = self
  end
end

class PORS < TreeGenotype([1,:rec], [:sto], [:+])
  N = (ARGV[1] || 32).to_i
  def fitness
    $pors_store = 0 # reset store
    -(eval_genes(:rec=>proc{$pors_store}) - N).abs*10 - 0.1 * size # find smallest tree with result 32
  end
end

pop = Population.new(PORS).evolve_on_console(500)
pp pop.max.genes

# n=31  1 + sto(sto(sto(1+1) + rec + 1) + rec + rec) + rec        , size 18


elsif ARGV[0]=='porsx'



# variant on pors, multiply T by some N, with only one access to T allowed

class Fixnum
  def sto
    $pors_store = self
  end
end

class PORS < TreeGenotype([:rec,:T], [:sto], [:+])
  N = (ARGV[1] || 31).to_i #  quite complicated optimal tree for 31
  def fitness
    -(0..5).map{|t| 
       $pors_store = 0 # reset store
       t_val = t
       values = {:rec=>proc{$pors_store},:T=>proc{ cv=t_val; t_val=0; cv}  } # using T destroys T
       (eval_genes(values) - N*t).abs 
    }.sum - 0.1*size # find a tree that multiplies T by 3
  end
end
=begin
solutions found for N=31: 
 sto(T) + sto( sto(rec+rec+rec) + rec ) + sto(rec+rec) + rec 	, size 19
 sto(T) + sto( sto(rec+rec) + sto(rec+rec) + rec) + rec + rec	, size 19
=end

pop = Population.new(PORS).evolve_on_console(500)
pp pop.max.genes

elsif ARGV[0]=='xor'
class Object; def not; !self; end;end

class XOR < TreeGenotype([:A,:B,true,false],[:not], [:&,:|])
  def fitness
    [[false,false],[false,true],[true,false],[true,true]].count{|a,b| eval_genes(:A=>a,:B=>b) == a^b } - $size_fac * size
  end
  cache_fitness
end
$size_fac = 0.01
pop, gen = Population.new(XOR).evolve_until(2000){|best| best.fitness > 3.9 }
puts "Generations needed (nil=no convergence) : #{gen}"
puts "Solution: #{pop.best}, fitness  #{pop.best.fitness}"


elsif ARGV[0]=='bloat'



# just generates huge trees.
class Bloat < TreeGenotype([1], [:+@], [:+])
  def fitness
    size
  end
  def to_s
   "[tree of size #{size}]"
  end
end

pop = Population.new(Bloat).evolve_on_console(200)

else
  puts "Several examples for tree genotypes."
  puts "Usage: ruby tree.rb cos|pors|porsx|xor|parity6|bloat"
end
