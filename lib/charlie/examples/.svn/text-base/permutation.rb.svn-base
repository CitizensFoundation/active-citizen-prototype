begin
  require '../lib/charlie'
rescue LoadError
  require 'rubygems'
  require 'charlie'
end


module MoneyBase
  def words
    s, e, n, d, m, o, r, y = genes # first 8 genes represent the 8 unique characters
    ["#{s}#{e}#{n}#{d}","#{m}#{o}#{r}#{e}","#{m}#{o}#{n}#{e}#{y}"].map(&:to_i)
  end
  def fitness
    send,more,money = words
    return -1e6 if send <= 999 || more <= 999 # no cheating by setting s or m to 0
    return -(money - (send+more)).abs
  end
  def to_s
    send,more,money = words
    "#{send}+#{more}=#{money}"
  end
end

puts "send+more=money problem as a permutation genotype"

class MoneyP < PermutationGenotype(10) # send+more=money problem as a permutation
  include MoneyBase
end

Population.new(MoneyP).evolve_on_console


=begin
# can also be done with StringGenotype, more effectively too.
# remember, string genotypes are just arrays with elements from some set, not necessarily chars.

class Money < StringGenotype(8,0..9) 
  include MoneyBase
  def fitness # no permutation, so need to have a penalty for reusing chars
    super - 100*(8 - genes.uniq.size)
  end
end

Population.new(Money).evolve_on_console

=end
