module SnsUtils
  module ParallelWorkers
    class UnixWorker

      IP_REGEX = /
          \b
          (#{IPv4::REGEX} | #{IPv6::REGEX} | #{MAC::REGEX})
          \b
      /xi

      attr_accessor :ips, :macs, :ip_writer, :mac_writer

      def initialize(ip_writer, mac_writer, file, line_range=nil)
        @ip_writer = ip_writer
        @mac_writer = mac_writer
        @file = file
        @line_range = init_line_range(line_range)
        @ips, @macs = [], []
      end

      def start
        extract_addresses
        report_ips
        report_macs
      end

      private

      def extract_addresses
        File.open(@file, 'r').each.with_index do |line, lineno|
          break if @line_range.end_line < lineno

          if @line_range.include?(lineno)
            line.scan(IP_REGEX).each do |md|
              log_address(md[0].to_s.strip)
            end
          end
        end
      end

      def init_line_range(line_range)
        line_range || LineRange.new(0, File.open(@file).count - 1)
      end

      def report_ips
        ips.each { |ip| @ip_writer.write("#{ip}\n") }
        @ip_writer.close
      end

      def report_macs
        macs.each { |mac| @mac_writer.write("#{mac}\n") }
        @mac_writer.close
      end

      def log_address(ip)
        ip = IPAddr.new(ip).to_string
        ips << ip
      rescue IPAddr::InvalidAddressError => e
        macs << ip
      rescue IPAddr::AddressFamilyError => e
        # TODO: report to parent stderr?
        return
      end
    end
  end
end
