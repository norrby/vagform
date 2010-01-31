class Ar
  include Math
  attr_reader :y
  attr_accessor :value

  def initialize(size)
    @size = size
    @value = 0
    @y = size.height
  end

  def calculate_x(a_value)
    @y * tan(PI/4 * ( 1 - (a_value/31)))
  end
  
  def calculate_value(x)
    31 / (PI/4) * (PI/4 - atan(x / @y))
  end
  
  def x
    calculate_x(@value)
  end

  def y=(y)
  end

  def x=(x)
    #x cannot be larger than it is on minimum slope
    max_x = calculate_x(0)
    new_x = (x > max_x) ? max_x : x
    new_x = (new_x < 0) ? 0 : new_x
    @value = calculate_value(new_x)
  end
end
