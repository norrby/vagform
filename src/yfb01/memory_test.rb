require 'memory'
require 'test/unit'

class MemoryTest < Test::Unit::TestCase
  include Memory

  def setup
    @data = Array.new(0x10, 0)
  end

  def test_store
    value = 6
    pos = 0x03
    mask = 0x07
    store(pos, mask, value)
    assert_equal value, @data[pos]
  end

  def test_masked_store
    value = 6
    pos = 0x03
    mask = 0x70
    store(pos, mask, value)
    assert_equal value << 4, @data[pos]
  end
end
