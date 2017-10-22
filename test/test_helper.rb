$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'complate'

require 'minitest/autorun'

def capture(stream)
  stream.inject(&:+)
end
