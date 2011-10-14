# encoding: utf-8
module NormalizedEditDistance
  class LineDescriptionFile

    attr_reader :lines ,:frontiers

    def initialize(file_name)
      @file_name= file_name
      @lines = Array.new
      @frontiers = Array.new
    end

    def read
      File.open(@file_name, "r:iso-8859-1") do |file|
        while (line = file.gets)
          process_line(line)
        end
      end
    end

    def process_line(line)
      values = line.split
      if values[0]=="Line"
        @lines.push values[2..3].map{|val| val.to_i}
        @frontiers.push lines.last[0]
        @frontiers.push lines.last[1]
      end
    end

  end
end