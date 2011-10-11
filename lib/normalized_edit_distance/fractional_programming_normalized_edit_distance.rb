module NormalizedEditDistance

  require 'ruby-debug'

  class FPNED

    attr_accessor :cost_function

    def initialize(x,y)
      @x = x
      @y = y
    end

    def calculate
      lned = LNED.new(@x,@y)
      lned.cost_function=@cost_function
      lambda_star = lned.calculate
      ued = UED.new(@x,@y)
      ued.cost_function = @cost_function
      begin

        lambda_prime = lambda_star
        @cost_function[:substitute]+=lambda_prime
        lambda_star = ued.calculate
        puts lambda_star
      end until lambda_star == lambda_prime

      lambda_star

    end
  end


end