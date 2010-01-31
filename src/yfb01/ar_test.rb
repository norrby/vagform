require 'test/unit'
require 'ar'

class ArTest < Test::Unit::TestCase

  class Rectangle
    attr_accessor :height, :width
    
    def initialize(width, height)
      @height, @width = height, width
    end

  end

  def setup
    @rect = Rectangle.new(2048.0, 1024.0)
    @ar = Ar.new(@rect)
  end

  def test_vertical_slope
    @ar.value = 31
    assert_equal @rect.height, @ar.y, "always on top"
    assert_equal 0, @ar.x, "maximum rate results in horizontal slope"
  end

  def test_45_slope
    @ar.value = 0
    assert_equal @rect.height, @ar.y, "always on top"
    assert_equal @rect.height, @ar.x, "minimum rate is 45 degrees"
  end

  def test_set_x_to_lower_slope
    @ar.x = @rect.height
    assert_equal 0, @ar.value, "45 degrees slope equals lowest rate"
  end

  def test_set_x_to_max_slope
    @ar.x = 0
    assert_equal 31, @ar.value, "45 degrees slope equals lowest rate"
  end
end
