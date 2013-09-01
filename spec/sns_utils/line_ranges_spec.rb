require_relative "../spec_helper"


describe SnsUtils::LineRanges do
  context ".calc(num_lines, num_ranges)" do
    it "returns one range" do
      ranges = SnsUtils::LineRanges.calc(20, 1)
      range = ranges.first

      ranges.length.should eql(1)
      range.start_line.should eql(0)
      range.end_line.should eql(19)
    end

    it "returns two ranges" do
      ranges = SnsUtils::LineRanges.calc(20, 2)
      range1, range2 = *ranges

      ranges.length.should eql(2)
      range1.start_line.should eql(0)
      range1.end_line.should eql(9)
      range2.start_line.should eql(10)
      range2.end_line.should eql(19)
    end

    it "returns three ranges" do
      ranges = SnsUtils::LineRanges.calc(20, 3)
      range1, range2, range3= *ranges

      ranges.length.should eql(3)
      range1.start_line.should eql(0)
      range1.end_line.should eql(5)
      range2.start_line.should eql(6)
      range2.end_line.should eql(11)
      range3.start_line.should eql(12)
      range3.end_line.should eql(19)
    end
  end
end
