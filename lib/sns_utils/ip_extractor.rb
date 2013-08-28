module SnsUtils
  class IpExtractor
    attr_accessor :file, :ip_addrs, :mac_addrs, :options

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
      write_ip_file
      write_mac_file
    end

    private

    def extract_addresses
      File.open(file, 'r').each do |line|
        line.scan(IP_REGEX).each do |match|
          log_ip(match[0].to_s.strip!)
        end
      end
    end

    def write_ip_file
      ips = ip_addrs.select { |_,count| count >= options.ip_threshold }
      write_file(::SnsUtils.ip_out_file, ips.keys)
    end

    def write_mac_file
      macs = mac_addrs.select { |_,count| count >= options.mac_threshold }
      write_file(::SnsUtils.mac_out_file, macs.keys)
    end

    def write_file(file, entries)
      File.open(file, "w+") do |f|
        entries.each { |e| f.puts(e) }
      end
    end

    def log_ip(ip)
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
        opts.on("-m N", Integer, "Log mac addresses with N occurrences") do |n|
          options.mac_threshold = Integer(n).abs
        end

        opts.on("-i N", Integer, "Log ip addresses with N occurrences") do |n|
          options.ip_threshold = Integer(n).abs
        end
      end

      parser.parse(argv)

      file = argv[0] || raise(OptionParser::InvalidOption.new)
      [file, options]
    end

  end
end
