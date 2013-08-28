require_relative "../spec_helper"

describe SnsUtils::IpExtractor do
  context "extracting IPv4 ips" do
    let(:file) { fixture_path("ipv4_simple.log") }

    it "finds valid entries" do
      extractor = SnsUtils::IpExtractor.new([file])
      extractor.run
      extractor.ip_addrs.should have(5).entries
    end
  end

  context "extracting IPv6 ips" do
    let(:file) { fixture_path("ipv6_simple.log") }

    it "finds valid entries" do
      extractor = SnsUtils::IpExtractor.new([file])
      extractor.run
      extractor.ip_addrs.should have(61).entries
    end
  end

  context "extracting MAC addresses" do
    let(:file) { fixture_path("mac_simple.log") }

    it "finds valid entries" do
      extractor = SnsUtils::IpExtractor.new([file])
      extractor.run
      extractor.mac_addrs.should have(2).entries
    end
  end

  context "extracting IPv4, IPv6, and MACs" do
    let(:file) { fixture_path("ipv4_ipv6_mac.log") }

    it "finds valid entries" do
      extractor = SnsUtils::IpExtractor.new([file])
      extractor.run

      extractor.ip_addrs.should have(5).entries
      extractor.mac_addrs.should have(1).entry
    end
  end

  context "Occurrence threshold options" do
    let(:file) { fixture_path("ipv4_ipv6_mac.log") }

    it "has a default IP threshold"
    it "adjusts IP threshold"
    it "has a default MAC threshold"
    it "adjusts MAC threshold"
  end
end
