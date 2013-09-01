module SnsUtils
  module LineRanges
    def self.calc(num_lines, num_ranges = 1)
      ranges = []
      range_length = num_lines / num_ranges

      start_line, end_line = 0, range_length-1
      num_ranges.times do
        ranges << LineRange.new(start_line, end_line)
        start_line, end_line = end_line + 1, end_line + range_length
      end
      ranges << LineRange.new(ranges.pop.start_line, num_lines-1)
    end
  end

  class LineRange
    attr_accessor :start_line, :end_line

    def initialize(start_line, end_line)
      @start_line, @end_line = start_line, end_line
      @range = Range.new(start_line, end_line)
    end

    def include?(line)
      @range.include?(line)
    end
  end
end
