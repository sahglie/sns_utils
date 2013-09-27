require 'pp'
require "strscan"
require 'ipaddr'
require "optparse"
require 'ostruct'

require_relative 'sns_utils/ipv4'
require_relative 'sns_utils/ipv6'
require_relative 'sns_utils/mac'
require_relative "sns_utils/address_extractor"
require_relative 'sns_utils/options'
require_relative 'sns_utils/line_ranges'
require_relative "sns_utils/parallel_workers"
require_relative "sns_utils/version"


module SnsUtils
  def self.root
    @root ||= File.expand_path(File.join(File.dirname(__FILE__), ".."))
  end

  def self.ip_out_file
    "ip_addrs.txt"
  end

  def self.mac_out_file
    "mac_addrs.txt"
  end

  def self.create_test_log(line, rep=1_000)
    File.open("#{::SnsUtils.root}/spec/fixtures/xlarge.log", "w+") do |f|
      rep.times do
        f.puts("2013-08-20 16:05:06,975 [http-8082-3] INFO  -   Rendered text template (0.0ms)")
        f.puts("2013-08-20 16:05:06,975 [http-8082-3] INFO  - Completed 200 OK in 5295ms (Views: 1.0ms | ActiveRecord: 0.0ms)")
        f.puts(line)
        f.puts("2013-08-20 16:08:39,281 [http-8082-3] INFO  - Redirected to https://apsearch-qa.berkeley.edu/login")
        f.puts("169.229.216.83 - - [25/Aug/2013:07:02:29 -0700] \"GET / HTTP/1.0\" 302 303 \"-\" \"check_http/v2053 (nagios-plugins 1.4.13)")
      end
    end
  end
end


if $PROGRAM_NAME == __FILE__
  line = "9.9.9 blah blah blah VALID 0.0.0.0 xxxx<<> 2001:0000:1234:0000:0000:C1C0:ABCD:0876 VALID >>> blah blah blah VALID 00:A0:C9:14:C8:29"
  ::SnsUtils.create_test_log(line, 100_000)
end

