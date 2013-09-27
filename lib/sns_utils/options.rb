module SnsUtils
  module Options

    def self.parse(argv)
      options = OpenStruct.new
      options.mac_threshold = 8
      options.ip_threshold = 10
      options.output_dir = nil
      options.num_workers = 1

      parser = OptionParser.new do |opts|
        opts.on("-m N", Integer, "MAC address threshold, logs entries with N <= occurrences") do |n|
          options.mac_threshold = Integer(n).abs
        end

        opts.on("-i N", Integer, "IP address threshold, logs entries with N =< occurrences") do |n|
          options.ip_threshold = Integer(n).abs
        end

        opts.on("-d OUTPUT_DIR", String, "Dir used to write output files") do |dir|
          options.output_dir = dir
        end

        opts.on("-w NUM_WORKERS", Integer, "Number of worker processes to use") do |n|
          options.num_workers = Integer(n)
          raise(OptionParser::InvalidArgument) if options.num_workers < 1
        end
      end

      parser.parse(argv)

      options
    end

  end
end
