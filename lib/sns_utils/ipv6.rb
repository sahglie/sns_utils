module SnsUtils
  # NOTE: the regexes are from Resolv::IPv4 in ruby's stdlib.  They were copied here because we
  # need to match IPs in the context of a large string and the Resolv regex has string start
  # and string end anchors which don't allow this.
  module IPv6
    ##
    # IPv6 address format a:b:c:d:e:f:g:h
    REGEX_8HEX = /
      (?:[0-9A-Fa-f]{1,4}:){7}
         [0-9A-Fa-f]{1,4}
    /x

    ##
    # Compressed IPv6 address format a::b
    REGEX_COMPRESSEDHEX = /
      (?:[0-9A-Fa-f]{1,4}(?::[0-9A-Fa-f]{1,4})*)? ::
      (?:[0-9A-Fa-f]{1,4}(?::[0-9A-Fa-f]{1,4})*)?
    /x

    ##
    # IPv4 mapped IPv6 address format a:b:c:d:e:f:w.x.y.z
    REGEX_6HEX4DEC = /
      (?:[0-9A-Fa-f]{1,4}:){6,6}
      \d+\.\d+\.\d+\.\d+
    /x

    ##
    # Compressed IPv4 mapped IPv6 address format a::b:w.x.y.z
    REGEX_COMPRESSEDHEX4DEC = /
      (?:[0-9A-Fa-f]{1,4}(?::[0-9A-Fa-f]{1,4})*)? ::
      (?:[0-9A-Fa-f]{1,4}:)*
      \d+\.\d+\.\d+\.\d+
    /x

    ##
    # A composite IPv6 address Regexp.
    REGEX = /
      (?:#{REGEX_8HEX}) |
      (?:#{REGEX_COMPRESSEDHEX}) |
      (?:#{REGEX_6HEX4DEC}) |
      (?:#{REGEX_COMPRESSEDHEX4DEC})
    /x
  end
end
