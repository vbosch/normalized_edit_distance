module NormalizedEditDistance

  require 'narray'

  class LNED

    attr_accessor :cost_function

    def initialize(x,y)
      @x = x
      @y = y
      @weight_matrix = NMatrix.float(@y.length+1,@x.length+1)
      @length_matrix = NMatrix.int(@y.length+1,@x.length+1)

    end

    def calculate

      initialize_cost_length_matrices

      (1..@x.length).each do |i|
        (1..@y.length).each do |j|
          update_position(i, j)
        end
      end

     @weight_matrix[@y.length,@x.length] / @length_matrix[@y.length,@x.length]

    end

    def initialize_cost_length_matries
      @weight_matrix[0, 0]=0
      @length_matrix[0, 0]=0
      (1..@x.length).each { |i| @weight_matrix[0, i]=@weight_matrix[0, i-1]+@cost_function.cost(@x[i-1],:lambda); @length_matrix[0, i]=@length_matrix[0, i-1]+1 }
      (1..@y.length).each { |j| @weight_matrix[j, 0]=@weight_matrix[j-1, 0]+@cost_function.cost(:lambda, @y[j-1]); @length_matrix[j, 0]=@length_matrix[j-1, 0]+1 }
    end



    def update_position(i, j)
      @weight_matrix[j, i]=calculate_substitution_cost(i,j); @length_matrix[j, i]=calculate_substitution_length(i,j)
      w_prime = calculate_deletion_cost(i,j); l_prime=calculate_deletion_length(i, j)
      if update?(i, j, l_prime, w_prime)
        @weight_matrix[j, i]=w_prime
        @length_matrix[j, i]=l_prime
      end
      w_prime = calculate_insertion_cost(i, j); l_prime=calculate_insertion_length(i, j)
      if update?(i, j, l_prime, w_prime)
        @weight_matrix[j, i]=w_prime
        @length_matrix[j, i]=l_prime
      end
    end

    def update?(i, j, l_prime, w_prime)
      w_prime/l_prime < @weight_matrix[j, i]/@length_matrix[j, i]
    end

    def calculate_substitution_cost(i,j)
      @weight_matrix[j-1, i-1]+@cost_function.cost(@x[i-1], @y[j-1])
    end

    def calculate_deletion_cost(i,j)
      @weight_matrix[j, i-1]+@cost_function.cost(@x[i-1],:lambda)
    end

    def calculate_insertion_cost(i, j)
      @weight_matrix[j-1, i]+@cost_function.cost(:lambda, @y[j-1])
    end

    def calculate_substitution_length(i,j)
      @length_matrix[j-1, i-1]+1
    end

    def calculate_deletion_length(i, j)
      @length_matrix[j, i-1]+1
    end

    def calculate_insertion_length(i, j)
      @length_matrix[j-1, i]+1
    end
  end

end
