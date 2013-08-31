require_relative "../spec_helper"

describe SnsUtils::Partitions do
  context ".calc(num_of_lines, num_of_partitions)" do
    it "returns one partition" do
      parts = SnsUtils::Partitions.calc(20, 1)
      one = parts[0]

      parts.length.should eql(1)
      one.start_line.should eql(1)
      one.end_line.should eql(20)
    end

    it "returns two partitions" do
      parts = SnsUtils::Partitions.calc(20, 2)
      one, two = parts[0], parts[1]

      parts.length.should eql(2)
      one.start_line.should eql(1)
      one.end_line.should eql(10)
      two.start_line.should eql(11)
      two.end_line.should eql(20)
    end

    it "returns three partitions" do
      parts = SnsUtils::Partitions.calc(20, 3)
      one, two, three = parts[0], parts[1], parts[2]

      parts.length.should eql(3)
      one.start_line.should eql(1)
      one.end_line.should eql(6)
      two.start_line.should eql(7)
      two.end_line.should eql(12)
      three.start_line.should eql(13)
      three.end_line.should eql(20)
    end
  end
end
