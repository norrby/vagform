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

class ArrayPart
include Enumerable

  def initialize(array, index, stop)
    @origin = array
    @start = index
    @stop = stop
  end

  def [](index)
    index_in_origin = index + @start
    return @origin[index_in_origin] if (@start..@stop).include? index_in_origin
    raise "out of bounds index[#{index}] (index_in_origin[#{index_in_origin}])"
  end

  def []=(index, value)
    index_in_origin = index + @start
    return @origin[index_in_origin]=value if (@start..@stop).include? index_in_origin
    raise "out of bounds index[#{index}] (index_in_origin[#{index_in_origin}])"
  end

  def length
    return to_a.length
  end

  def each
    (@start..@stop).each {|idx| yield @origin[idx]}
  end
end
