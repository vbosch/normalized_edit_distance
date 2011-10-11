module NormalizedEditDistance

  require 'narray'
  require_relative './unormalized_edit_distance'
  require 'ruby-debug'
  class LNED < UED

    def update?(i, j, l_prime, w_prime)
      puts "HELLO"
      w_prime/l_prime.to_f < @weight_matrix[j, i]/@length_matrix[j, i].to_f
    end

  end

end
