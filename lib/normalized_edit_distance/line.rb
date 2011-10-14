module NormalizedEditDistance
  class Line
    def initialize
      @costs = Hash.new
      @costs[:delete]=1.0
      @costs[:insert]=1.0
      @costs[:substitute]=2.0
    end


    def cost(from,to)

      return @costs[:insert] * (to[0]-to[1]).abs if insertion?(from,to)

      return @costs[:delete] * (from[0]-from[1]).abs if deletion?(from,to)

      @costs[:substitute]* ((to[0]-from[0]).abs + (to[1]-from[1]).abs)

    end

    def format_type(line)
      return "0 0" if frontier == :epsilon
      "#{line[0]} #{line[1]}"
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