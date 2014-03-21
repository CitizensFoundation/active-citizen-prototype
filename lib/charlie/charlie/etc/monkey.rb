# I should probably replace some of this with a dependency on facets(?) or some other library.
# update: Ruby 1.9 has many of these anyway

class Numeric
  def between(minval,maxval)
    [[self,minval].max,maxval].min
  end
end

module Enumerable
  def group_by
    ret = {}
    each{|e| (ret[yield(e)] ||= []) << e }
    ret
  end if RUBY_VERSION < '1.9'

  def count
    count = 0
    each {|e| count+=1 if yield(e) }
    count
  end  if RUBY_VERSION < '1.9'

  def zip_with(a2,&b)
    zip(a2).map(&b)
  end

#  def sum
#    r=0; each{|e| r+=e }; r
#  end

  alias_method :enum_slice, :each_slice unless RUBY_VERSION < '1.9' # ruby1.9 replaces enum_* with each_*
end

class Array
 if RUBY_VERSION < '1.9'
  def shuffle ; sort_by { rand }; end
  def shuffle!; replace shuffle; end
  def find_index(&b); index find(&b); end
 end

  def dot_product(v)
    r=0.0
    each_with_index{|e,i| r+=e*v[i] }
    r
  end

  def rand_index
    Kernel.rand(size)
  end

  def at_rand
    self[Kernel.rand(size)]
  end

  def stats # TODO 1.9, use minmax
    return transpose.map(&:stats).transpose if at(0).is_a?(Array) # return stats of each component if elements are arrays
    [min,max,average,stddev]
  end

  def average
    sum.to_f / size
  end
  
  def stddev
    mu = average
    Math.sqrt( map{|x| (x-mu)*(x-mu) }.sum / size )
  end

  def map_with_index # TODO 1.9
   r=[]
   each_with_index{|e,i| r << yield(e,i) }
   r
  end

  # Finds value and swaps it with the element at index.
  def swap_element_at_index!(index, value)
    old_element_index = self.index(value)
    self[index], self[old_element_index] = value, self[index]
  end

end


class String
  def rand_index
    rand(size)
  end

  def rand_at
    self[rand(size)]
  end

  def chars
    split('')
  end if RUBY_VERSION < '1.9'
  
  def each_char(&b)
    chars.each(&b)
  end if RUBY_VERSION < '1.9'
end

class Symbol
  undef_method :[] unless RUBY_VERSION < '1.9' # kill the 1.9 warning
  # This function was added because :npoint[3] just looks so much nicer than [:npoint,3]
  def [](*args)
    [self,*args]
  end

  def to_proc
    Proc.new { |*args| args.shift.__send__(self, *args) }
  end if RUBY_VERSION < '1.9'

  def intern
    self
  end if RUBY_VERSION < '1.9'
end

class Module
  def metaclass
    class << self;self;end
  end

  # Used to give anonymous modules a name.
  def name=(n)
    metaclass.class_eval{ define_method(:to_s){ n } } # avoid send for ruby 1.9
  end
end




