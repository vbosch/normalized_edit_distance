module NormalizedEditDistance

  require 'narray'
  require 'ruby-debug'
  class UED

    attr_accessor :type_helper, :operations

    def initialize(x,y)
      @x = x
      @y = y
      @calculated = false
      @path = Array.new
      @weight_matrix = NMatrix.float(@x.length+1,@y.length+1)
      @length_matrix = NMatrix.int(@x.length+1,@y.length+1)
      @operations = {:substitution => 0, :insertion => 0, :deletion => 0}

    end

    def path
      calculate_path if @path.empty?
      @path
    end

    def standard_normalized_cost
      calculate unless @calculated
      @weight_matrix[@x.length,@y.length] / @length_matrix[@x.length,@y.length].to_f
    end

    def plain_cost
      calculate unless @calculated
      @weight_matrix[@x.length,@y.length]
    end



    def ponderated_normalized_cost
      calculate unless @calculated
      @weight_matrix[@x.length,@y.length]/ponderated_length

    end

    def ponderated_length
      calculate_path
      @operations[:substitution]*@type_helper[:substitute]+@operations[:insertion]*@type_helper[:insert]+@operations[:deletion]*@type_helper[:delete]
    end

    def ponderated_substitution_length
      calculate_path
      @operations[:substitution]*@type_helper[:substitute]
    end


    def calculate

      initialize_matrices

      (1..@x.length).each do |i|
        (1..@y.length).each do |j|
          #puts "at #{i}-#{j} #{@x[i-1]} #{@y[j-1]} "
          update_position(i, j)
        end
      end
      @calculated = true

    end

    def initialize_matrices
      @weight_matrix[0, 0]=0.0
      @length_matrix[0, 0]=0
      (1..@x.length).each { |i| @weight_matrix[i, 0]=@weight_matrix[i-1, 0]+@type_helper.cost(@x[i-1],:lambda); @length_matrix[i, 0]=@length_matrix[i-1, 0]+1 }
      (1..@y.length).each { |j| @weight_matrix[0, j]=@weight_matrix[0, j-1]+@type_helper.cost(:lambda, @y[j-1]); @length_matrix[0, j]=@length_matrix[0, j-1]+1 }
    end



    def update_position(i, j)
      @weight_matrix[i, j]=calculate_substitution_cost(i,j); @length_matrix[i, j]=calculate_substitution_length(i,j)
      w_prime = calculate_deletion_cost(i,j); l_prime=calculate_deletion_length(i, j)
      if update?(i, j, l_prime, w_prime)
        @weight_matrix[i, j]=w_prime
        @length_matrix[i, j]=l_prime
      end
      w_prime = calculate_insertion_cost(i, j); l_prime=calculate_insertion_length(i, j)
      if update?(i, j, l_prime, w_prime)
        @weight_matrix[i, j]=w_prime
        @length_matrix[i, j]=l_prime
      end
    end

    def update?(i, j, l_prime, w_prime)
      w_prime < @weight_matrix[i, j]
    end

    def calculate_substitution_cost(i,j)
      @weight_matrix[i-1, j-1]+@type_helper.cost(@x[i-1], @y[j-1])
    end

    def calculate_deletion_cost(i,j)
      @weight_matrix[i-1,j]+@type_helper.cost(@x[i-1],:lambda)
    end

    def calculate_insertion_cost(i, j)
      @weight_matrix[i, j-1]+@type_helper.cost(:lambda, @y[j-1])
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

    def calculate_path
      if is_calculated?
        @operations = {:substitution => 0, :insertion => 0, :deletion => 0}
        @path.clear
        current_position = [@x.length,@y.length]
        while not is_origin?(current_position)
          operation = operation_backtrack(current_position)
          @operations[operation]+=1
          update_path(current_position,operation)
          current_position = update_path_position(current_position,operation)
        end

      end
    end

    def operations_breakdown_hash
      require 'ap'
      costs = []
      lengths = []
      if is_calculated?
        current_position = [@x.length,@y.length]
        while not is_origin?(current_position)
          operation = operation_backtrack(current_position)
          costs = update_costs(costs,current_position,operation)
          lengths= update_lengths(lengths,current_position,operation)
          current_position = update_path_position(current_position,operation)
        end

      end
      return {:costs=> costs,:lengths => lengths}
    end

    def update_costs(costs,current_position,operation)
      costs.push(@type_helper.cost(@x[current_position[0]-1], @y[current_position[1]-1])) if operation == :substitution
      costs.push(@type_helper.cost(@x[current_position[0]-1], :lambda)) if operation == :insertion
      costs.push(@type_helper.cost(:lambda, @y[current_position[1]-1])) if operation == :deletion
      return costs
    end

    def update_lengths(lengths,current_position,operation)
      lengths.push(@type_helper[:substitute]) if operation == :substitution
      lengths.push(@type_helper[:insert]) if operation == :insertion
      lengths.push(@type_helper[:delete]) if operation == :deletion
      return lengths
    end

    def substitution_cost_only
      cost = 0.0
      ops = 0.0
      if is_calculated?
        @operations = {:substitution => 0, :insertion => 0, :deletion => 0}
        current_position = [@x.length,@y.length]
        while not is_origin?(current_position)
          operation = operation_backtrack(current_position)
          if operation == :substitution
            @operations[operation]+=1
            cost+= @type_helper.cost(@x[current_position[0]-1], @y[current_position[1]-1])
            ops += 1.0
          end
          current_position = update_path_position(current_position,operation)
        end

      end
      cost
    end

    def is_origin?(current_position)
      current_position == [0,0]
    end

    def is_calculated?
      @calculated
    end

    def operation_backtrack(position)
      return :substitution if @weight_matrix[position[0],position[1]] == calculate_substitution_cost(position[0],position[1]) and position[0] > 0 and position[1] >0
      return :deletion if @weight_matrix[position[0],position[1]] == calculate_deletion_cost(position[0],position[1]) and position[0]>0
      :insertion
    end

    def update_path_position(current_position,operation)
      return [current_position[0]-1,current_position[1]-1] if operation == :substitution
      return [current_position[0]-1,current_position[1]] if operation == :deletion
      [current_position[0],current_position[1]-1]  if operation == :insertion
    end

    def update_path(current_position,operation)
      @path.insert(0,[operation,current_position[0]-1 >= 0 ? @x[current_position[0]-1] : :epsilon ,current_position[1]-1>=0 ? @y[current_position[1]-1] : :epsilon])
    end

    def path_to_file(file_name)
      File.open(file_name, "w") do |file|
        path.each do |operation|
          file.puts operation_to_s(operation)
        end
      end
    end

    def operation_to_s(operation)
      "#{operation[0]} #{type_helper.format_type(operation[1])} #{type_helper.format_type(operation[2])}"
    end

  end

end
