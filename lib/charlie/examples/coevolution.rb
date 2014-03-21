begin
  require '../lib/charlie'
rescue LoadError
  require 'rubygems'
  require 'charlie'
end

if ARGV[0].nil?
  puts "Several examples for Co-evolution."
  puts "Usage: ruby coevolution.rb simple|sunburn|prisoner"




elsif ARGV[0].downcase.gsub(/[^a-z]/,'') == 'simple'




puts "Running a simple co-evolutionary genetic algorithm. Drives the first gene towards +infinity, and the second towards -infinity."

class TestFighter <  FloatListGenotype(2)
  def fight(other) # fight(other) return true if self wins, false if self loses
    if rand < 0.5
      genes[0] >= other.genes[0]
    else
      genes[1] <= other.genes[1]
    end
  end

  def to_s
    genes.map{|f| '%02f' % f }.join(', ')
  end
  use GladiatorialSelection
  use UniformCrossover
  use ListMutator(:expected_n[1],:gaussian[0.25])
end

pop = Population.new(TestFighter,10).evolve_silent(500)
puts pop





elsif ARGV[0].downcase.gsub(/[^a-z]/,'') == 'sunburn'


puts "Running a co-evolutionary genetic algorithm for strings that represent combatting space ships."
puts "M - Missile, most effective at long ranges."
puts "L - Laser  , medium effectiveness at all ranges."
puts "G - Gun    , most effective at short ranges." 
puts "S - 3 Shields, soak up damage." 
puts "D - Drive, can change distance to other ship, need to have at least one left to claim a win."

# The sunburn fighter genotype consists of 20 characters and an integer (its preferred starting range).
# These represent spaceships, who fight and co-evolve
# One of the ways to make such a mixed genotype is to do the mutation of one half yourself.
# This is one of the harder things to do.
class SunburnFighter <  StringGenotype(20,"SGLMD")

  def initialize
    @gene_range = rand * 20
    super
  end
  def gene_range; @gene_range.between(0,20); end

  WEAPONS = {'L'=>proc{|r| 0.35               }, # laser: constant effectiveness
             'M'=>proc{|r| 0.1 + (r-1) / 38.0 }, # missile: effectiveness increases with range
             'G'=>proc{|r| 0.6 - (r-1) / 38.0 }, # gun: effectiveness decreases with range
             'D'=>proc{|r| 0.0 }, # drives don't fire
             'S'=>proc{|r| 0.0 }  # shields don't fire
            }

  def genes
    super + [@gene_range]
  end

  def genes=(g)
    @gene_range = g.pop
    super(g)
  end

  def weapons
    genes[0..-2]
  end
 
  def fight(other)
    pref_range = [self.gene_range, other.gene_range]
    cur_range = pref_range.sum / 2.0
    turn = 0
    weap = [self.weapons,other.weapons]
    weap = weap.map{|w| s = w.count{|e|e=='S'}*3 ; w.delete 'S'; ['S']*s + w } # fix shields in front
    # fight

    100.times{ # 100 turns at most
      dmg = [0,1].map{|t| weap[t].map{|w| rand < WEAPONS[w].call(cur_range) ? 1 : 0 }.sum } # calculate and sum up damage
      [0,1].each{|t| weap[t] = weap[t][dmg[1-t]..-1] || [] } # apply damage
      break if weap.any?(&:empty?) # is one of the ships destroyed?
      dr = [0,1].map{|t| weap[t].count{|e|e=='D'} }
      while dr[0]+dr[1] > 0 # move ships with drives left towards their preferred range
        dir = [0,1].map{|t| ((pref_range[t] - cur_range) / 100.0).ceil }
        [0,1].each{|t| 
         if dr[t] > 0
          cur_range += dir[t] 
          dr[t] -= 1
         end
        }
      end
    }
    return rand < 0.5 unless weap.any?{|a| a.include? 'D' } # It's a draw unless one has drives left.
    return weap[0].include?('D') # else return true if self won, false if other won
  end

  def to_s
    "#{@genes.join} #{'%.1f' % @gene_range}"
  end

  def mutate!
    @gene_range = PointMutators[:uniform].call(@gene_range,2.0)
    super
  end

  use GladiatorialSelection, UniformCrossover
end

puts '-'*75
puts "Running first test"


pop = Population.new(SunburnFighter,20).evolve_silent(200)
puts "Results:",pop

# other effectiveness curves, much slower/longer fights
SunburnFighter::WEAPONS.replace( {'L'=>proc{|r| 0.6 / ((r-6)**2 + 1)  },
                                  'M'=>proc{|r| 0.5 / ((r-9)**2 + 1) },
                                  'G'=>proc{|r| 0.7 / ((r-3)**2 + 1) },
                                  'D'=>proc{|r| 0.0 },
                                  'S'=>proc{|r| 0.0 }
                                 })
puts "Second test. More local effectiveness ranges, fights take longer."
pop = Population.new(SunburnFighter,20).evolve_silent(50)
puts "Results:",pop



elsif ARGV[0].downcase.gsub(/[^a-z]/,'') == 'prisoner'




puts "Runs a tournament-based co-evolutionary genetic algorithm of the Prisoner's Dilemma. "

class Prisoner <  BitStringGenotype(5)
  RESULT = {'00'=>1,'01'=>5,'10'=>0,'11'=>3}
#look at last ft, 00 01 10 11 -> ix in genes .. genes[4] = init
# rev for other! 3-x?
  def fight_points(other) # fight_points(other) return [points for self,points for other]
    strat, other_strat = genes, other.genes
    move, other_move = strat[4], other_strat[4] # initial move
    s, os = 0,0
    100.times{
      my_res = "#{move}#{other_move}"
      other_res = my_res.reverse
      s  += RESULT[my_res]
      os += RESULT[other_res]
      move, other_move = strat[my_res.to_i(2)], other_strat[other_res.to_i(2)]
    }
    [s,os]
  end
  BIT = ['D','C']
  NAMES = { # name some strategies
    "1111"=>"ALL-C","0000"=>"ALL-D","0101"=>"TIT-FOR-TAT","0001"=>"GRUDGE (ALL-D-AFTER-ANY-D)","1001"=>"PAVLOV",
    "0011"=>"ALL-START","0100"=>"ALL-C-AFTER-ANY-C","0111"=>"ALL-C-IF-START-C"
  }
  def to_s
    long_name = "DD => #{BIT[genes[0]]} CD => #{BIT[genes[2]]} | DC => #{BIT[genes[1]]}  CC=>#{BIT[genes[3]]}  | START #{BIT[genes[4]]}"
    "#{long_name} \t #{NAMES[super[0..3]]}"
  end
  use CoTournamentSelection(5), UniformCrossover, ListMutator(:expected_n[0.25],:flip)
end

pop = Population.new(Prisoner,50).evolve_silent(200)
puts "PREVIOUS MOVE OF SELF/OTHER => ACTION \t\t\t NAME"
puts pop


end