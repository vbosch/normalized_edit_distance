module NormalizedEditDistance

  require 'narray'
  require_relative './unormalized_edit_distance'
  require 'ruby-debug'
  class LNED < UED

    def update?(i, j, l_prime, w_prime)
      w_prime/l_prime.to_f < @weight_matrix[i, j]/@length_matrix[i, j].to_f
    end

  end

end
