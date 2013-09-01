module SnsUtils
  class AddressExtractor
    attr_accessor :file, :options
    attr_accessor :ip_addrs, :mac_addrs
    attr_accessor :worker_pids
    attr_accessor :ip_reader, :ip_writer
    attr_accessor :mac_reader, :mac_writer

    def initialize(argv)
      @file = argv[0] || raise(OptionParser::InvalidOption.new)
      @options = ::SnsUtils::Options.parse(argv)
      @ip_addrs, @mac_addrs = Hash.new(0), Hash.new(0)
      @worker_pids = []
    end

    def run
      start_workers
      #register_signals
      wait_for_workers
      read_addresses
      log_addresses
      self
    end

    private

    def start_workers
      @ip_reader, @ip_writer = IO.pipe
      @mac_reader, @mac_writer = IO.pipe

      num_lines = File.open(file).count
      ranges = LineRanges.calc(num_lines, options.num_workers)

      ranges.each do |line_range|
        worker_pids << fork do
          @ip_reader.close
          @mac_reader.close
          start_worker(@ip_writer, @mac_writer, file, line_range)
        end
      end

      @ip_writer.close
      @mac_writer.close
    end

    def start_worker(ip_writer, mac_writer, file, line_range)
      ParallelWorkers::UnixWorker.new(ip_writer, mac_writer, file, line_range).start
    end

    def register_signals
      [:INT, :QUIT].each do |sig|
        Signal.trap(sig) do
          worker_pids.each { |pid| Process.kill(sig, pid) }
        end
      end
    end

    def wait_for_workers
      worker_pids.each { Process.wait }
    rescue Errno::ECHILD
      # noop
    end

    def read_addresses
      ip_reader.read.split("\n").each do |line|
        ip, count = line.split(" ")
        ip_addrs[ip] += count.to_i
      end
      ip_reader.close

      mac_reader.read.split("\n").each do |line|
        mac, count = line.split(" ")
        mac_addrs[mac] += count.to_i
      end
      mac_reader.close
    end

    def log_addresses
      ip_addrs.select! { |_, count| count >= options.ip_threshold }
      mac_addrs.select! { |_, count| count >= options.mac_threshold }
      write_file(::SnsUtils.ip_out_file, ip_addrs.keys)
      write_file(::SnsUtils.mac_out_file, mac_addrs.keys)
    end

    def write_file(file, entries)
      file_path = output_dir(options.output_dir, file)
      File.open(file_path, "w+") do |f|
        entries.each { |ip| f.puts(ip) }
      end
    end

    def output_dir(dir, file)
      dir ? File.expand_path(File.join(dir, file)) : file
    end
  end
end
