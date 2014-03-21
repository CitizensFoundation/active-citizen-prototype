begin
  require '../lib/charlie'
rescue LoadError
  require 'rubygems'
  require 'charlie'
end

DATA = [[-1,-1],[-1,1],[1,-1],[1,1]]
class XOR < NeuralNetworkGenotype(2,3,1)
  def fitness
    DATA.map{|i1,i2|  -(output([i1,i2])[0] - i1*i2)**2  }.sum
  end
  def to_s
    genes.map{|f| "%.2f" % f}.join(',')
  end
  cache_fitness
end
b=Population.new(XOR,50).evolve_on_console(200).best
puts " ===== RESULTS ===== "
DATA.each{|i| puts "#{i.inspect} => #{b.output(i).inspect}" }
