require_relative "../spec_helper"

describe SnsUtils::IpExtractor do
  context "extracting IPv4 ips" do
    let(:file) { fixture_path("ipv4_simple.log") }

    it "finds valid IPs" do
      extractor = SnsUtils::IpExtractor.new([file])
      extractor.run

      expect(extractor.ip_addrs).to have(5).entries
    end
  end

  context "extracting Full IPv6 ips" do
    let(:file) { fixture_path("ipv6_simple.log") }

    it "finds valid IPs" do
      extractor = SnsUtils::IpExtractor.new([file])
      extractor.run

      expect(extractor.ip_addrs).to have(61).entries
    end
  end

  context "extracting MAC addresses" do
    let(:file) { fixture_path("mac_simple.log") }

    it "finds valid IPs" do
      extractor = SnsUtils::IpExtractor.new([file])
      extractor.run

      expect(extractor.mac_addrs).to have(2).entries
    end
  end

  context "extracting IPv4, IPv6, and MACs" do
    let(:file) { fixture_path("ipv4_ipv6_mac.log") }

    it "finds valid IPs" do
      extractor = SnsUtils::IpExtractor.new([file])
      extractor.run

      expect(extractor.ip_addrs).to have(5).entries
      expect(extractor.mac_addrs).to have(1).entry
    end
  end
end
