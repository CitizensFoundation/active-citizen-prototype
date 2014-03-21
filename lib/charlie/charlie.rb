require 'enumerator'

$:.unshift File.dirname(__FILE__)

# This is just a dummy module to avoid making the VERSION constant a global.
module Charlie
  VERSION = '0.8.1'
end

require 'charlie/etc/monkey'
require 'charlie/etc/minireport'

require 'charlie/population'
require 'charlie/networked_population'

require 'charlie/selection'
require 'charlie/crossover'
require 'charlie/mutate'

require 'charlie/genotype'


require 'charlie/list/list_mutate'
require 'charlie/list/list_crossover'
require 'charlie/list/list_genotype'

require 'charlie/list/matrix'

require 'charlie/list/neural'

require 'charlie/permutation/permutation'

require 'charlie/tree/tree'

require 'charlie/gabenchmark'

if RUBY_VERSION >= '1.9'
  require 'charlie/1.9fixes'
end

