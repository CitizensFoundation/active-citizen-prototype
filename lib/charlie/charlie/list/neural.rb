# This file contains everything related to neural network genotypes

# The tanh function is the default
NN_TANH = proc{|x| Math.tanh x }
# The sign function is also commonly used
NN_SIGN = proc{|x| x>=0?1:-1 }

# Genotype for neural networks with a single hidden layer.
# * Inherits FloatListGenotype
# * input_n, hidden_n, output_n are the number of neurons at each layer
# * scaling determines how the floats in genes relate to the weights of the links (important for mutation size, initial values).
#   * input to hidden  weights are (list element) multiplied by scaling / input_n
#   * hidden to output weights are (list element) multiplied by scaling / hidden_n
# * hidden_f, output_f are the (usually sigmoidal) functions to determine the output of nodes.
#   * Output of hidden node i is  hidden_f( weights . input - threshold)
# ----------------------------------------------------
# functions of the returned class:
# * output(input) - runs the neural network in some input
def NeuralNetworkGenotype(input_n,hidden_n,output_n=1,scaling=1.0,hidden_f=NN_TANH,output_f=NN_TANH)
  links_n = hidden_n * (input_n + output_n)
  thr_n = hidden_n  + output_n
  Class.new(FloatListGenotype(links_n+thr_n, -1..1 )) {
    define_method(:output){|input|
      raise ArgumentError unless input.size==input_n
      si = scaling / input_n
      sh = scaling / hidden_n

      wts = genes
      input = input.map{|i| i * si } # scale inputs instead of weights: same effect, but faster

      hidden_val = Array.new(hidden_n,0.0)
      output_val = Array.new(output_n,0.0)
      (0...hidden_n).each{|i|
        wi    = i * input_n
        thr = wts[links_n + i]
        v = 0.0
        (0...input_n).each{|j| v += input[j] * wts[wi + j] }
        hidden_val[i] = hidden_f.call(v - thr) * sh # again, scale this instead of hidden->output weights
      }
      oi = hidden_n * input_n
      (0...output_n).each{|i|
        wi = oi + i * hidden_n
        thr = wts[links_n + hidden_n + i]
        v = 0.0
        (0...hidden_n).each{|j| v +=  hidden_val[j] * wts[wi + j] }
        output_val[i] = output_f.call(v - thr)
      }
      output_val
    }
    use UniformCrossover.dup
  }
end
