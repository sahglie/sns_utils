# SnsUtils

Find and extract IP and MAC addresses in FILE based on repeated occurrences.

## Installation

Add this line to your application's Gemfile:

    gem 'sns_utils'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sns_utils

## Usage
    $ gem install gem-man (if you haven't already)
    $ gem man sns_utils

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Performance Notes

### Grep Baseline Perf

The following grep commands try to match only IPv6 addresses using the
same regex as the addrex utility

xlarge.log is 5GB with 50 million lines

    time grep -c  -E '\b(?:(?:[0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(?:[0-9A-Fa-f]{1,4}(?::[0-9A-Fa-f]{1,4})*)?::(?:[0-9A-Fa-f]{1,4}(?::[0-9A-Fa-f]{1,4})*)?|(?:[0-9A-Fa-f]{1,4}:){6,6}\d+\.\d+\.\d+\.\d+|(?:[0-9A-Fa-f]{1,4}(?::[0-9A-Fa-f]{1,4})*)?::(?:[0-9A-Fa-f]{1,4}:)*\d+\.\d+\.\d+\.\d+)\b' spec/fixtures/xlarge.log
    => Exceeded 15 min


xlarge.log is 514MB with 5 million lines

    time grep -c  -E '\b(?:(?:[0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(?:[0-9A-Fa-f]{1,4}(?::[0-9A-Fa-f]{1,4})*)?::(?:[0-9A-Fa-f]{1,4}(?::[0-9A-Fa-f]{1,4})*)?|(?:[0-9A-Fa-f]{1,4}:){6,6}\d+\.\d+\.\d+\.\d+|(?:[0-9A-Fa-f]{1,4}(?::[0-9A-Fa-f]{1,4})*)?::(?:[0-9A-Fa-f]{1,4}:)*\d+\.\d+\.\d+\.\d+)\b' spec/fixtures/xlarge.log
    => real 1m12.063s
       user 1m11.956s
       sys  0m0.108s

## ip_extract

xlarge.log is 514MB with 5 million lines

    addrex spec/fixtures/xlarge.log
    => real 3m7.938s
       user 3m6.356s
       sys  0m0.578s

