module RSpecHelper
  module BadValues
    # Invalid values for common types
    INVALID_ARRAY = [{}, 1, 'foo', '', true].freeze
    INVALID_BOOL = [[], {}, 1, '1', 'foo', ''].freeze
    INVALID_STRING = [[], {}, 1, '', true, false].freeze
  end
end
