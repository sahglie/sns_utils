require_relative "../spec_helper"

describe SnsUtils::AddressExtractor do
  context "Occurrence threshold options" do
    let(:file) { fixture_path("thresholds.log") }

    it "raises error for invalid thresholds" do
      expect { SnsUtils::AddressExtractor.new([file, "-i", "x"]) }.to \
          raise_error(OptionParser::InvalidArgument)

      expect { SnsUtils::AddressExtractor.new([file, "-m", "x"]) }.to \
          raise_error(OptionParser::InvalidArgument)
    end

    it "has default IP and MAC threshold" do
      addrex = SnsUtils::AddressExtractor.new([file])
      addrex.options.mac_threshold.should eql(8)
      addrex.options.ip_threshold.should eql(10)
    end

    it "uses default IP and MAC threshold" do
      addrex = SnsUtils::AddressExtractor.new([file])
      addrex.run

      addrex.ip_addrs.should have(1).entry
      addrex.mac_addrs.should have(1).entry
    end

    it "adjusts default IP and MAC threshold" do
      addrex = SnsUtils::AddressExtractor.new([file, "-i", "5", "-m", "4"])
      addrex.options.mac_threshold.should eql(4)
      addrex.options.ip_threshold.should eql(5)
    end

    it "uses adjusted IP and MAC threshold" do
      addrex = SnsUtils::AddressExtractor.new([file, "-i", "5", "-m", "5"]).run
      addrex.ip_addrs.should have(2).entries
      addrex.mac_addrs.should have(2).entries

      addrex = SnsUtils::AddressExtractor.new([file, "-i", "11", "-m", "11"]).run
      addrex.ip_addrs.should be_empty
      addrex.mac_addrs.should be_empty
    end
  end

  context "Num workers option" do
    let(:file) { fixture_path("thresholds.log") }

    it "raises error for invalid thresholds" do
      expect { SnsUtils::AddressExtractor.new([file, "-w", "0"]) }.to \
          raise_error(OptionParser::InvalidArgument)

      expect { SnsUtils::AddressExtractor.new([file, "-w", "-1"]) }.to \
          raise_error(OptionParser::InvalidArgument)
    end

    it "defaults to a single worker" do
      addrex = SnsUtils::AddressExtractor.new([file])
      addrex.options.num_workers.should eql(1)
    end

    it "adjusts number of workers" do
      addrex = SnsUtils::AddressExtractor.new([file, "-w", "5"])
      addrex.options.num_workers.should eql(5)
    end
  end

  context "Output dir option" do
    let(:file) { fixture_path("ipv4_simple.log") }
    let(:tmp_dir) { "#{::SnsUtils.root}/tmp" }

    after(:all) do
      File.delete("#{tmp_dir}/#{::SnsUtils.ip_out_file}")
      File.delete("#{tmp_dir}/#{::SnsUtils.mac_out_file}")
    end

    it "configures custom output directory" do
      options = SnsUtils::AddressExtractor.new([file, "-d", tmp_dir]).options
      options.output_dir.should eql(tmp_dir)
    end

    it "writes to custom output directory" do
      SnsUtils::AddressExtractor.new([file, "-d", tmp_dir]).run
      File.exists?("#{tmp_dir}/#{::SnsUtils.ip_out_file}").should be_true
      File.exists?("#{tmp_dir}/#{::SnsUtils.mac_out_file}").should be_true
    end
  end
end
