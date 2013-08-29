require_relative "../spec_helper"

describe SnsUtils::IpExtractor do
  context "extracting IPv4 ips" do
    let(:file) { fixture_path("ipv4_simple.log") }

    it "finds valid entries" do
      ipex = SnsUtils::IpExtractor.new([file]).run
      ipex.ip_addrs.should have(5).entries
    end
  end

  context "extracting IPv6 ips" do
    let(:file) { fixture_path("ipv6_simple.log") }

    it "finds valid entries" do
      ipex = SnsUtils::IpExtractor.new([file]).run
      ipex.ip_addrs.should have(96).entries
    end
  end

  context "extracting MAC addresses" do
    let(:file) { fixture_path("mac_simple.log") }

    it "finds valid entries" do
      ipex = SnsUtils::IpExtractor.new([file]).run
      ipex.mac_addrs.should have(2).entries
    end
  end

  context "extracting IPv4, IPv6, and MACs" do
    let(:file) { fixture_path("ipv4_ipv6_mac.log") }

    it "finds valid entries" do
      ipex = SnsUtils::IpExtractor.new([file]).run
      pp ipex.ip_addrs
      ipex.ip_addrs.should have(5).entries
      ipex.mac_addrs.should have(1).entry
    end
  end

  context "Occurrence threshold options" do
    let(:file) { fixture_path("thresholds.log") }

    it "raises error for invalid thresholds" do
      expect { SnsUtils::IpExtractor.new([file, "-i", "x"]) }.to \
          raise_error(OptionParser::InvalidArgument)

      expect { SnsUtils::IpExtractor.new([file, "-m", "x"]) }.to \
          raise_error(OptionParser::InvalidArgument)
    end

    it "has default IP and MAC threshold" do
      ipex = SnsUtils::IpExtractor.new([file])
      ipex.options.mac_threshold.should eql(8)
      ipex.options.ip_threshold.should eql(10)
    end

    it "uses default IP and MAC threshold" do
      ipex = SnsUtils::IpExtractor.new([file])
      ipex.run

      ipex.ip_addrs_log.should have(1).entry
      ipex.mac_addrs_log.should have(1).entry
    end

    it "adjusts default IP and MAC threshold" do
      ipex = SnsUtils::IpExtractor.new([file, "-i", "5", "-m", "4"])
      ipex.options.mac_threshold.should eql(4)
      ipex.options.ip_threshold.should eql(5)
    end

    it "uses adjusted IP and MAC threshold" do
      ipex = SnsUtils::IpExtractor.new([file, "-i", "5", "-m", "5"]).run
      ipex.ip_addrs_log.should have(2).entries
      ipex.mac_addrs_log.should have(2).entries

      ipex = SnsUtils::IpExtractor.new([file, "-i", "11", "-m", "11"]).run
      ipex.ip_addrs_log.should be_empty
      ipex.mac_addrs_log.should be_empty
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
      options = SnsUtils::IpExtractor.new([file, "-d", tmp_dir]).options
      options.output_dir.should eql(tmp_dir)
    end

    it "writes to custom output directory" do
      SnsUtils::IpExtractor.new([file, "-d", tmp_dir]).run
      File.exists?("#{tmp_dir}/#{::SnsUtils.ip_out_file}").should be_true
      File.exists?("#{tmp_dir}/#{::SnsUtils.mac_out_file}").should be_true
    end
  end
end


describe "SnsUtils::IpExtractor" do
  context "extracting edge cases" do
    let(:file) { fixture_path("edge_cases.log") }

    it "finds valid entries" do
      ipex = SnsUtils::IpExtractor.new([file]).run

      pp ipex.ip_addrs
      ipex.ip_addrs.should have(10).entries
    end
  end
end
