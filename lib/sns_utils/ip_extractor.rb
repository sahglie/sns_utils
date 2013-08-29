module SnsUtils
  class IpExtractor
    attr_accessor :file, :options
    attr_accessor :ip_addrs, :ip_addrs_log, :mac_addrs, :mac_addrs_log

    IPV4_REGEX = ::SnsUtils::IPv4::REGEX
    IPV6_REGEX = ::SnsUtils::IPv6::REGEX
    MAC_REGEX = ::SnsUtils::MAC::REGEX
    IP_REGEX = / ((?: ^|\s) (?: #{IPV6_REGEX} | #{IPV4_REGEX} | #{MAC_REGEX}) (?: \s|$)) /xi

    def initialize(argv)
      @file, @options = parse_options(argv)
      self.ip_addrs = {}
      self.mac_addrs = {}
    end

    def run
      extract_addresses
      log_ip_addrs
      log_mac_addrs
      self
    end

    private

    def extract_addresses
      File.open(file, 'r').each do |line|
        line.scan(IP_REGEX).each { |md| log_addr(md[0].to_s.strip!) }
      end
    end

    def log_ip_addrs
      self.ip_addrs_log  = ip_addrs.select { |_, count| count >= options.ip_threshold }.keys
      write_file(::SnsUtils.ip_out_file, ip_addrs_log)
    end

    def log_mac_addrs
      self.mac_addrs_log = mac_addrs.select { |_, count| count >= options.mac_threshold }.keys
      write_file(::SnsUtils.mac_out_file, mac_addrs_log)
    end

    def write_file(file, entries)
      File.open(file, "w+") do |f|
        entries.each { |e| f.puts(e) }
      end
    end

    def log_addr(ip)
      key = IPAddr.new(ip).to_string
      ip_addrs[key] ||= 0
      ip_addrs[key] += 1
    rescue IPAddr::InvalidAddressError => e
      mac_addrs[ip] ||= 0
      mac_addrs[ip] += 1
    end

    def parse_options(argv)
      options = OpenStruct.new
      options.mac_threshold = 8
      options.ip_threshold = 10

      parser = OptionParser.new do |opts|
        opts.on("-m N", Integer, "MAC address threshold, logs entries with N <= occurrences") do |n|
          options.mac_threshold = Integer(n).abs
        end

        opts.on("-i N", Integer, "IP address threshold, logs entries with N =< occurrences") do |n|
          options.ip_threshold = Integer(n).abs
        end

        #opts.on("-d N", Integer, "IP address threshold, logs entries with N =< occurrences") do |n|
        #  options.ip_threshold = Integer(n).abs
        #end
      end

      parser.parse(argv)

      file = argv[0] || raise(OptionParser::InvalidOption.new)
      [file, options]
    end
  end
end
