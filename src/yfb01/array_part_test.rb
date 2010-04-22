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
