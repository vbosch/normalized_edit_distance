module NormalizedEditDistance

  class Char
    def initialize

      @costs = Hash.new
      @costs[:delete]=2.0
      @costs[:insert]=2.0
      @costs[:substitute]=3.0
    end

    def cost(from,to)

      return @costs[:insert] if insertion?(from,to)

      return @costs[:delete] if deletion?(from,to)

      if from == to
        0
      else
        @costs[:substitute]
      end

    end

    def format_type(char)
      return ' ' if frontier == :epsilon
      char
    end

    def insertion?(from,to)
      from == :lambda and to != :lambda
    end

    def deletion?(from,to)
      from != :lambda and to == :lambda
    end

    def [](operation)
      @costs[operation]
    end

    def []=(operation,value)
      @costs[operation]=value
    end

  end
end