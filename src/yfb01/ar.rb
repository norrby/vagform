#  .
# VAGFORM, a MIDI Synth Editor
# Copyright (C) 2010  M Norrby
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
