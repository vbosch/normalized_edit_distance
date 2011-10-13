module NormalizedEditDistance

  require 'ruby-debug'

  class FPNED

    attr_accessor :cost_function

    def initialize(x,y)
      @x = x
      @y = y
      @lned = LNED.new(@x,@y)
      @ued = UED.new(@x,@y)
    end

    def calculate
      @lned.cost_function=@cost_function
      @ued.cost_function = @cost_function
      lambda_star = @lned.calculate
      begin
        lambda_prime = lambda_star
        @cost_function[:substitute]+=lambda_prime
        puts "subs_cost #{@cost_function[:substitute]}"
        lambda_star = @ued.calculate
        puts "#{lambda_prime}-#{lambda_star}"
      end until lambda_star == lambda_prime
      lambda_star
    end

    def path
      @ued.path
    end

    def path_to_file(file_name)
      File.open(file_name, "w") do |file|
        @ued.path.each do |operation|
          file.puts operation_to_s(operation)
        end
      end
    end

    def operation_to_s(operation)
      "#{operation[0]} #{operation[1][0]} #{operation[1][1]} #{operation[2][0]} #{operation[2][1]}"
    end

  end


end