require 'rbconfig' # for install name

module GABenchmark
  extend self

  # This method generates reports comparing several selection/crossover/mutation methods. Check the examples directory for several examples. See the BENCHMARK documentation file for more information.
  def benchmark(genotype_class, html_outfile='report.html', csv_outfile=nil, &b)
    start = Time.now

    dsl_obj = StrategiesDSL.new; dsl_obj.instance_eval(&b)
    all_tests        = dsl_obj.get_tests
    generations      = dsl_obj.generations
    population_size  = dsl_obj.population_size
    repeat_tests     = dsl_obj.repeat
    setup_proc       = dsl_obj.setup
    teardown_proc    = dsl_obj.teardown

    track_stat  = dsl_obj.track_stat

    n_tests = all_tests.size
    tests_done = 0
    puts "#{n_tests} Total tests:"

    overall_best = [nil, -1.0 / 0.0]
 
    data = all_tests.map{|selection_module,crossover_module,mutator_module|
      tests_done += 1
      print "\nRunning test #{tests_done}/#{n_tests} : #{selection_module} / #{crossover_module} / #{mutator_module}\t"

      gclass = Class.new(genotype_class) { use selection_module,crossover_module,mutator_module }
      start_test = Time.now

      test_stats = (0...repeat_tests).map{
        print '.'; $stdout.flush

        population = Population.new(gclass,population_size)
        setup_proc.call(population)
        best = population.evolve_silent(generations).last

        stat = track_stat.call(best)
        teardown_proc.call(population)

        overall_best = [best, stat] if overall_best[0].nil? || (overall_best[1] <=> stat) < 0 # use <=> to allow arrays
        stat
      }
      [selection_module, crossover_module,mutator_module,
       (Time.now-start_test) / repeat_tests,  test_stats]
    }

    html_output(html_outfile, data, genotype_class, Time.now-start, overall_best, dsl_obj)
    csv_output(csv_outfile  , data)

    puts '',table_details(data).to_s
    return data
  end


  private

  ST_HEADINGS = %w[min max avg stddev time]
  
  def format_stat(s)
    if s.is_a?(Array)
      s.map{|x|format_stat(x)}.join("\r\n")
    else
      '%.5f' % s
    end
  end

  def table_details(data)
    tabledata = data.map{|s,c,m,t,a|
      [s,c,m] + (a.stats << t).map{|f| format_stat(f)} 
    }.sort_by{|row| -row[-3].to_f } # sort by avg fitness. highest to lowest. to_f on multiple formatted returns first
    return tabledata.to_table(%w[selection crossover mutation] + ST_HEADINGS)
  end

  def table_group(datasets,g1_name) # array of title, data rows
    tabledata = datasets.map{|title,dataset|
      joined   = dataset.map(&:last).inject{|a,b|a+b}
      avg_time = dataset.map{|r| r[-2] }.average
      [title] + (joined.stats << avg_time).map{|f| format_stat(f)} 
    }.sort_by{|row| -row[-3].to_f } # sort by average fitness
    return tabledata.to_table([g1_name]+ST_HEADINGS).to_html
  end

  def html_output(html_outfile, data, genotype_class, tot_time, overall_best, dsl_obj )
    return unless html_outfile
   # Generate HTML
    html_tables = <<INFO
      <h1>Information</h1>\n
      <table>
        <tr><th colspan=2>Version Info</th></tr>
        <tr><td>Ruby Install Name</td><td>#{Config::CONFIG['ruby_install_name']}</td></tr>
        <tr><td>Ruby Version</td><td>#{RUBY_VERSION}</td></tr>
        <tr><td>Charlie Version</td><td>#{Charlie::VERSION}</td></tr>
        <tr><th colspan=2>Benchmark Info</th></tr>
        <tr><td>Genotype class</td><td>#{genotype_class}</td></tr>
        <tr><td>Population size</td><td>#{dsl_obj.population_size}</td></tr>
        <tr><td>Number of generations per run</td><td>#{dsl_obj.generations}</td></tr>
        <tr><td>Number of tests </td><td>#{data.size}</td></tr> 
        <tr><td>Tests repeated </td><td>#{dsl_obj.repeat} times</td></tr> 
        <tr><td>Number of runs </td><td>#{data.size * dsl_obj.repeat}</td></tr> 
        <tr><td>Total number of generations </td><td>#{data.size * dsl_obj.repeat * dsl_obj.generations}</td></tr> 
        <tr><td>Total time</td><td>#{'%.2f' % tot_time} seconds</td></tr>
        <tr><th colspan=2>Best Solution Info</th></tr>
        <tr><td>Fitness</td><td>#{overall_best[1].inspect}</td></tr>
        <tr><td>Solution</td><td><textarea rows=3 cols=40>#{overall_best[0].to_s}</textarea></td></tr>
      </table>
INFO

   
    # - Combined stats
    html_tables << "<h1>Stats for all</h1>"
    html_tables <<  table_group([["All",data]],'')
    # - stats grouped by selection, crossover, mutation methods
    ["selection","crossover","mutation"].each_with_index{|title,i|
      html_tables << "<h1>Stats for #{title}</h1>"
      html_tables << table_group(data.group_by{|x|x[i]}, title)
    }
    # - detailed stats
    html_tables << '<h1>Detailed Stats</h1>' <<  table_details(data).to_html
      # write HTML stats
    File.open(html_outfile,'w'){|f|
      template = File.read(File.dirname(__FILE__)+"/../../data/template.html")
      f << template.sub('{{CONTENT}}',html_tables)
    }
  end

  def csv_output(csv_outfile,data)
    return unless csv_outfile
    File.open(csv_outfile,'w'){|f|
      f << data.map{|r|r[0..2] << r[-1].inspect }.to_table.to_csv 
    }
  end
 

# Used in the GABenchmark#benchmark function.
class StrategiesDSL
  class << self
    def attr_dsl(x)
      x = x.to_s
      attr_accessor x
      alias_method 'get_'+x, x  # rename reader
      define_method(x) {|*args| # reader with 0 args, write with 1 arg
        return send('get_'+x) if args.empty?
        args.size > 1 ? send(x+'=',args) : send(x+'=',*args)
      }
    end
  end

  # Number of generations run in each test.
  attr_dsl :generations
  # Population size used.
  attr_dsl :population_size
  # Number of times all tests are run. Default=10. Increase for more accuracy on the benchmark.
  attr_dsl :repeat

  # Pass several modules to this to test these selection methods.
  attr_dsl :selection
  # Pass several modules to this to test these crossover methods.
  attr_dsl :crossover
  # Pass several modules to this to test these mutation methods.
  attr_dsl :mutator
  alias :mutation  :mutator
  alias :mutation= :mutator=

  def initialize
    @repeat          = 10
    @population_size = 20 
    @generations     = 50 
    @setup = @teardown = proc{}
    selection []
    crossover []
    mutator   []
    track_stat{|best| best.fitness } # tracks maximum fitness by default
  end

  # Pass a block that returns one or more statistics to track. Block is passed the individual with the highest fitness after each run.
  # * Can be used to track, for example, training error vs generalization error.
  # * Default is fitness of the best solution.
  # * When returning multiple values, <=> for arrays is used to determine the best individual in the info table (i.e. second elements only for tie-breaking), but min/max/avg/stddev stats are calculated independently for each component
  def track_stat(&b)
    return @track_stat unless block_given?
    @track_stat = b
  end
  alias :track_stats :track_stat

  # Pass a block that does the setup. Rarely needed. The proc is passes the population before each test (i.e. between Population.new and #evolve_silent)
  def setup(&b)
    return @setup unless block_given?
    @setup = b
  end

  # Pass a block that does the setup. Rarely needed. Called with the population as argument AFTER track_stats.
  def teardown(&b)
    return @teardown unless block_given?
    @teardown = b
  end

  # Get all the tests. Basically a cartesian product of all selection, crossover and mutation methods.
  def get_tests
    t = []

    defmod = Module.new{self.name='default'}

    selection = [@selection].flatten ; selection = [defmod] if selection.empty?
    crossover = [@crossover].flatten ; crossover = [defmod] if crossover.empty?
    mutator   = [@mutator].flatten   ; mutator   = [defmod] if   mutator.empty?

    selection.each{|s|
     crossover.each{|c| 
      mutator.each{|m|
       t << [s,c,m]
      }
     }
    }
    t
  end
end



end # GABenchmark





=begin
class RoyalRoad <  BitStringGenotype(64)  # Royal Road problem
  def fitness
    1 + genes.enum_slice(8).find_all{|e| e.all?{|x|x==1} }.size # +1 to avoid all fitness 0 for roulette
  end
  cache_fitness
end

GABenchmark.benchmark(RoyalRoad,'test_bitstring_royalroad.html','o.csv'){
  selection TruncationSelection(0.3),
            Elitism(ScaledRouletteSelection)

  crossover NullCrossover, UniformCrossover

  mutator   ListMutator(:expected_n[5],:flip)

  generations    100
  repeat          2 #
  population_size 17
 
  track_stat{|b| [b.fitness,b.genes.count{|x|x==1}] }
}
=end
