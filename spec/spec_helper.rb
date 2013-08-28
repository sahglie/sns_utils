require_relative '../lib/sns_utils'

RSpec.configure do |config|
end

def fixture_path(file)
  File.expand_path(File.join(SnsUtils.root, "spec", "fixtures", file))
end
