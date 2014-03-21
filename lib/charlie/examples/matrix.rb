begin
  require '../lib/charlie'
rescue LoadError
  require 'rubygems'
  require 'charlie'
end
require 'pp'

if ARGV[0]=='royalmatrix'

puts "Like bitstring.rb royalroad, but with a matrix."

class RRMatrix < BitMatrixGenotype(16,4)
  def fitness
    genes.count{|row| row.all?{|b| b==1 } }
  end
  def to_s ; genes.map{|row| row.all?{|b| b==1 } ? '*':'_' }.join ; end
  use MatrixMutator(:expected_n_per_row[0.1],:flip), UniformCrossover # row-based uniform crossover
end
r = Population.new(RRMatrix).evolve_on_console(200)

elsif ARGV[0]=='inverse'

puts "Evolves the inverse of a matrix. Not very effective."

N = 3
M = Array.new(N){Array.new(N){rand}}
I = (0...N).map{|i|  (0...N).map{|j| j==i ? 1 : 0 }}

class MInverse < FloatMatrixGenotype(N,N,-1..1)
  def fitness
    a = genes; b = M
    diff = 0
    (0...N).each{|i|  (0...N).each{|j|
      diff += (I[i][j] - (0...N).map{|k| a[i][k] * b[k][j] }.sum).abs
    }}
    -diff
  end
  def to_s
    "\n" + genes.map{|r| r.map{|e| "%.2f" % e }.join("\t") }.join("\n")
  end
  use MatrixMutator(:expected_n[3],:gaussian[0.1])
end
r = Population.new(MInverse).evolve_on_console(200)

else
  puts "Several examples for matrices."
  puts "Usage: ruby matrix.rb royalmatrix|inverse"
end
