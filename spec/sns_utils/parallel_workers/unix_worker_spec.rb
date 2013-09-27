require_relative "../../spec_helper"


describe "ParallelWorkers::UnixWorker" do
  let(:worker) { SnsUtils::ParallelWorkers::UnixWorker.new(StringIO.new, StringIO.new, file) }

  context "extracting IPv4 ips" do
    let(:file) { fixture_path("ipv4_simple.log") }

    it "finds valid entries" do
      worker.start
      worker.ips.should have(5).entries
    end
  end

  context "extracting IPv6 ips" do
    let(:file) { fixture_path("ipv6_simple.log") }

    it "finds valid entries" do
      worker.start
      worker.ips.should have(119).entries
    end
  end

  context "extracting MAC addresses" do
    let(:file) { fixture_path("mac_simple.log") }

    it "finds valid entries" do
      worker.start
      worker.macs.should have(2).entries
    end
  end

  context "extracting IPv4, IPv6, and MACs" do
    let(:file) { fixture_path("ipv4_ipv6_mac.log") }

    it "finds valid entries" do
      worker.start

      worker.ips.should have(5).entries
      worker.macs.should have(1).entry
    end
  end

  context "extracting edge cases" do
    let(:file) { fixture_path("edge_cases.log") }

    it "finds valid entries" do
      worker.start
      worker.ips.should have(7).entries
    end
  end
end
