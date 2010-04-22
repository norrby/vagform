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
