module NormalizedEditDistance

  require 'narray'
  require 'ruby-debug'
  class UED

    attr_accessor :cost_function

    def initialize(x,y)
      @x = x
      @y = y
      @weight_matrix = NMatrix.float(@x.length+1,@y.length+1)
      @length_matrix = NMatrix.int(@x.length+1,@y.length+1)

    end

    def calculate

      initialize_matrices

      (1..@x.length).each do |i|
        (1..@y.length).each do |j|
          #puts "at #{i}-#{j} #{@x[i-1]} #{@y[j-1]} "
          update_position(i, j)
        end
      end
      @weight_matrix[@x.length,@y.length] / @length_matrix[@x.length,@y.length].to_f

    end

    def initialize_matrices
      @weight_matrix[0, 0]=0.0
      @length_matrix[0, 0]=0
      (1..@x.length).each { |i| @weight_matrix[i, 0]=@weight_matrix[i-1, 0]+@cost_function.cost(@x[i-1],:lambda); @length_matrix[i, 0]=@length_matrix[i-1, 0]+1 }
      (1..@y.length).each { |j| @weight_matrix[0, j]=@weight_matrix[0, j-1]+@cost_function.cost(:lambda, @y[j-1]); @length_matrix[0, j]=@length_matrix[0, j-1]+1 }
    end



    def update_position(i, j)
      @weight_matrix[i, j]=calculate_substitution_cost(i,j); @length_matrix[i, j]=calculate_substitution_length(i,j)
      #puts @weight_matrix[i, j]
      w_prime = calculate_deletion_cost(i,j); l_prime=calculate_deletion_length(i, j)
      #puts w_prime
      if update?(i, j, l_prime, w_prime)
        #puts "DELETION"
        @weight_matrix[i, j]=w_prime
        @length_matrix[i, j]=l_prime
      end
      w_prime = calculate_insertion_cost(i, j); l_prime=calculate_insertion_length(i, j)
      #puts w_prime
      if update?(i, j, l_prime, w_prime)
        #puts "INSERTION"
        @weight_matrix[i, j]=w_prime
        @length_matrix[i, j]=l_prime
      end
    end

    def update?(i, j, l_prime, w_prime)
      w_prime < @weight_matrix[i, j]
    end

    def calculate_substitution_cost(i,j)
      @weight_matrix[i-1, j-1]+@cost_function.cost(@x[i-1], @y[j-1])
    end

    def calculate_deletion_cost(i,j)
      @weight_matrix[i-1,j]+@cost_function.cost(@x[i-1],:lambda)
    end

    def calculate_insertion_cost(i, j)
      @weight_matrix[i, j-1]+@cost_function.cost(:lambda, @y[j-1])
    end

    def calculate_substitution_length(i,j)
      @length_matrix[i-1, j-1]+1
    end

    def calculate_deletion_length(i, j)
      @length_matrix[i-1, j]+1
    end

    def calculate_insertion_length(i, j)
      @length_matrix[i, j-1]+1
    end
  end

end
