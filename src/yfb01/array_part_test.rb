require 'test/unit'
require 'array_part'

class ArrayPartTest < Test::Unit::TestCase
  def test_equal_arrays
    a = [1, 2, 3, 4]
    b = ArrayPart.new(a, 0, 3)
    assert_equal a[1], b[1]
    assert_equal a.length, b.length
  end

  def test_write
    a = [1, 2, 3]
    b = ArrayPart.new(a, 1, 2)
    b[1] = "zebra"
    assert_equal "zebra", a[2]
  end
end
