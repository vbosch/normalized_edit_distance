# encoding: utf-8
module NormalizedEditDistance
  class LineDescriptionFile

    attr_reader :lines ,:frontiers

    def initialize(file_name,frontiers_to_consider)
      @file_name= file_name
      @lines = Array.new
      @frontiers = Array.new
      @frontiers2consider = frontiers_to_consider
    end

    def read
      File.open(@file_name, "r:iso-8859-1") do |file|
        while (line = file.gets)
          process_line(line)
        end
      end
    end

    def process_initial_frontier?
      @frontiers2consider == :initial or @frontiers2consider == :both
    end

    def process_last_frontier?
          @frontiers2consider == :last or @frontiers2consider == :both
    end

    def process_line(line)
      values = line.split
      if values[0]=="Line"
        @lines.push values[2..3].map{|val| val.to_i}

        @frontiers.push lines.last[0] if process_initial_frontier?
        @frontiers.push lines.last[1] if process_last_frontier?
      end
    end

  end
end