module NormalizedEditDistance
  require 'ruby-debug'

  class Frontier

    def initialize(x,y)
      @costs = Hash.new
      @costs[:delete]=1.0
      @costs[:insert]=1.0
      @costs[:substitute]=2.0
      initialize_difference(x,y)
    end

    def initialize_difference(x,y)
      @insertion_difference = Hash.new
      @deletion_difference = Hash.new
      x.each_with_index{|val,index| @deletion_difference[val]=(val- (index-1<0 ? 0 : (index-1 > y.length-1 ? y.last : y[index-1]) )).abs if @deletion_difference[val].nil?}
      y.each_with_index{|val,index| @insertion_difference[val]=(val- (index-1<0 ? 0 : (index-1 > x.length-1 ? x.last : x[index-1]) )).abs if @insertion_difference[val].nil?}
    end

    def cost(from, to)

      return @costs[:insert] * @insertion_difference[to] if insertion?(from, to)

      return @costs[:delete] * @deletion_difference[from] if deletion?(from, to)

      @costs[:substitute]* (to-from).abs

    end

    def format_type(frontier)
      return 0 if frontier == :epsilon
      frontier.to_s
    end

    def insertion?(from, to)
      from == :lambda and to != :lambda
    end

    def deletion?(from, to)
      from != :lambda and to == :lambda
    end

    def [](operation)
      @costs[operation]
    end

    def []=(operation, value)
      @costs[operation]=value
    end
  end
end