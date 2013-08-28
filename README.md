# SnsUtils

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'sns_utils'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sns_utils

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


# Notes on Performance

## Grep Baseline Perf

xlarge.log is 5GB with 50 million lines

`time grep -c  -E '(?:[0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4}' spec/fixtures/xlarge.log`
=> real 12m0.658s
   user 11m59.672s
   sys  0m0.991s


xlarge.log is 514MB with 5 million lines

`time grep -c  -E '(?:[0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4}' spec/fixtures/xlarge.log`
=> real 1m12.063s
   user 1m11.956s
   sys  0m0.108s

## ip_extract

xlarge.log is 514MB with 5 million lines

`ip_extract spec/fixtures/xlarge.log`
=> real 2m18.938s
   user 2m18.356s
   sys  0m0.578s


