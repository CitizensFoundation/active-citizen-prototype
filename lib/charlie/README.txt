== Charlie version 0.8.1
* http://rubyforge.org/projects/charlie/
* http://charlie.rubyforge.org
* mailto:sander.land+ruby@gmail.com

== DESCRIPTION:
Charlie is a library for genetic algorithms (GA) and genetic programming (GP).

== FEATURES:
- Quickly develop GAs by combining several parts (genotype, selection, crossover, mutation) provided by the library.
- Sensible defaults are provided with any genotype, so often you only need to define a fitness function.
- Easily replace any of the parts by your own code.
- Test different strategies in GA, and generate reports comparing them.  Example report: http://charlie.rubyforge.org/example_report.html

== INSTALL:
* sudo gem install charlie

== Documentation
Because of the high amount of metaprogramming used in the package, the rdoc documentation is incomplete and also contains some non-existent functions.

The following pages contain overviews of the most important parts, including pointers to the appropriate pages of the documentation.
* Genotypes[link:files/data/GENOTYPE.html]
* Population
* Selection[link:files/data/SELECTION.html]
* Crossover[link:files/data/CROSSOVER.html]
* Mutation[link:files/data/MUTATION.html]
* Benchmarking[link:files/data/BENCHMARK.html]
Also see the 'examples' directory included in the tarball or gem for several examples, where most of the functionality is used.

== EXAMPLES:
This example solves a TSP problem (also quiz #142):
 N=5
 CITIES = (0...N).map{|i| (0...N).map{|j| [i,j] } }.inject{|a,b|a+b}
 class TSP < PermutationGenotype(CITIES.size)
   def fitness
     d=0
     (genes + [genes[0]]).each_cons(2){|a,b| 
        a,b=CITIES[a],CITIES[b]
        d += Math.sqrt( (a[0]-b[0])**2 + (a[1]-b[1])**2 ) 
      }
     -d # lower distance -> higher fitness.
   end
   use EdgeRecombinationCrossover, InversionMutator
 end
 Population.new(TSP,20).evolve_on_console(50)

This example finds a polynomial which approximates cos(x)
 class Cos < TreeGenotype([proc{3*rand-1.5},:x], [:-@], [:+,:*,:-])
   def fitness
    -[0,0.33,0.66,1].map{|x| (eval_genes(:x=>x) - Math.cos(x)).abs }.max
   end
   use TournamentSelection(4)
 end
 Population.new(Cos).evolve_on_console(500)


== LICENSE:

(The MIT License)

Copyright (c) 2007, 2008 Sander Land

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
