# List crossovers: SinglePointCrossover, UniformCrossover, NPointCrossover


# Simple single point crossover, returns two children.
module SinglePointCrossover
  def cross(parent1,parent2)
    cross_pt = rand(parent1.size+1)
    [ parent1.genes[0...cross_pt] + parent2.genes[cross_pt..-1],
      parent2.genes[0...cross_pt] + parent1.genes[cross_pt..-1]].map{|x| from_genes(x) }
  end
end

# n point crossover, returns two children.
def NPointCrossover(n=2)
 Module.new{
  puts "NPointCrossover"
  self.name = "NPointCrossover(#{n})"
  define_method(:cross){|parent1,parent2|
    p1 = parent1.genes; p2 = parent2.genes
    upper_bnd = p1.size + 1
    cross_pts = (0...n).map{rand(upper_bnd)}.sort

    c1 = []; c2=[]
    ([0] + cross_pts << upper_bnd).each_cons(2){|cp1,cp2|
      c1 += p1[cp1...cp2]
      c2 += p2[cp1...cp2]
      p1,p2 = p2,p1
    }
    [c1,c2].map{|x| from_genes(x) }
  }
 }
end
TwoPointCrossover   = NPointCrossover(2)
ThreePointCrossover = NPointCrossover(3)

# Uniform crossover, returns two children.
module UniformCrossover
  def cross(parent1,parent2)
#     puts "UniformCrossover"
#    puts parent1
#    puts parent2
#    if parent1.to_s==parent2.to_s
#      puts "CROSSOVER SAMESAMESAME"
#    else
#      puts "CROSSOVER DIFFERENTDIFFERENT"    
#    end
#    puts "UniformCrossover in genotype1: #{parent1.object_id} #{@genes}"
#    puts "UniformCrossover in genotype2: #{parent2.object_id} #{@genes}"
    c1 = []; c2=[]
    g1 = parent1.genes;
    g2 = parent2.genes
    g1.each_with_index{|e,i|
      if Kernel.rand(2).zero?
        c1 << e; c2 << g2[i]
      else
        c2 << e; c1 << g2[i]
      end
    }
    out = [c1,c2].map{|x| from_genes(x) }
#    puts "UniformCrossover out: #{out.inspect}"
    out
  end
end

module ComboCrossover
  def cross(parent1_in,parent2_in)
#    puts "ComboCrossover"
    parent1 = Marshal::load(Marshal.dump(parent1_in)) 
    parent2 = Marshal::load(Marshal.dump(parent2_in)) 
#    parent1 = parent1_in.clone
#    parent2 = parent2_in.clone
    parent1_genotypes = parent1.get_genotypes
    parent2_genotypes = parent2.get_genotypes
    inp =  [parent1,parent2]
#    puts "ComboCrossover inp: #{inp.inspect}"    
    for number in 0..parent1_genotypes.length-1
      result = parent1_genotypes[number].class.cross(parent1_genotypes[number], parent2_genotypes[number])
#      debugger
      parent1.set_genotype_item(number, result[0])
      parent2.set_genotype_item(number, result[1])
#      debugger
    end
#    out = [parent1,parent2].map{|x| from_genes(x) }
    out = [parent1,parent2]
#    puts "ComboCrossover out: #{out.inspect}"    
    out
  end
end

# Blending crossover, common in evolutionary strategies.
# * Given two parents x1(i), x2(i)
# * Returns two children with as i'th elements  y(i)x1(i)+(1-y(i))x2(i)  and  y(i)x2(i)+(1-y(i))x1(i)
# * type=:cube takes y(i) independent, so children roughly within the hypercube spanned by the parents.
# * type=:line takes y(i)=y(1), so children roughly on the line between the parents.
# * <tt>exploration_alpha</tt> defines how far outside the hypercube/line spanned by the parents the children can be. (more specifically, y(i) = (1+2*alpha)*rand - alpha)
def BlendingCrossover(exploration_alpha=0.1,type=:cube)
  sz_rand = 1 + 2 * exploration_alpha
  Module.new{
    puts "BlendingCrossover"  
    self.name = "BlendingCrossover(#{exploration_alpha},#{type})"
    if(type==:cube) 
      define_method(:cross){|parent1,parent2|
        c1 = []; c2=[]; g1 = parent1.genes; g2 = parent2.genes
        g1.each_with_index{|e,i|
          y  = rand*sz_rand - exploration_alpha 
          x2 = g2[i]
          c1 << y*e  + (1-y)*x2
          c2 << y*x2 + (1-y)*e
        }
        [c1,c2].map{|x| from_genes(x) }
      }
    elsif(type==:line) 
      define_method(:cross){|parent1,parent2|
        c1 = []; c2=[]; g1 = parent1.genes; g2 = parent2.genes
        y  = rand*sz_rand - exploration_alpha 
        g1.each_with_index{|e,i|
          x2 = g2[i]
          c1 << y*e  + (1-y)*x2
          c2 << y*x2 + (1-y)*e
        } 
        [c1,c2].map{|x| from_genes(x) }
      }
    else 
      raise ArgumentError,"Invalid BlendingCrossover type #{type}"
    end
  }
end
BlendingCrossover=BlendingCrossover()

