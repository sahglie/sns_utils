module SnsUtils
  module Partitions
    def self.calc(num_of_lines, num_of_partitions = 1)
      partitions = []
      partition_length = num_of_lines / num_of_partitions

      start_line, end_line = 1, partition_length
      num_of_partitions.times do
        partitions.push(Partition.new(start_line, end_line))
        start_line, end_line = end_line + 1, end_line + partition_length
      end
      partitions.last.end_line = num_of_lines
      partitions
    end
  end

  class Partition < Struct.new(:start_line, :end_line)
  end
end
