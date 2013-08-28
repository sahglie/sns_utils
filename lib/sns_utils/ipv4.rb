module SnsUtils
  # NOTE: the regexes are from Resolv::IPv4 in ruby's stdlib.  They were copied here because we
  # need to match IPs in the context of a large string and the Resolv regex has string start
  # and string end anchors which don't allow this.
  module IPv4
    REGEX_256 = /0
               |1(?:[0-9][0-9]?)?
               |2(?:[0-4][0-9]?|5[0-5]?|[6-9])?
               |[3-9][0-9]?/x
    REGEX = /#{REGEX_256}\.#{REGEX_256}\.#{REGEX_256}\.#{REGEX_256}/x
  end
end
