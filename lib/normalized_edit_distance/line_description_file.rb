# encoding: utf-8
module NormalizedEditDistance
  class LineDescriptionFile

    attr_reader :line_limits

    def initialize(file_name)
      @file_name= file_name
      @line_limits = Array.new
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
        line_limits.push values[2..3].map{|val| val.to_i}
      end
    end

  end
end