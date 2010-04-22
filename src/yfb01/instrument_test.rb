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
# -*- coding: iso-8859-1 -*-
require 'test/unit'
require 'instrument'

class InstrumentTest < Test::Unit::TestCase
  def setup
    @dump = Array.new(0x10, 0)
    @inst = Instrument.new(nil, @dump)
  end

  def test_notes
    notes = 8
    @dump[0] = notes
    assert_equal notes, @inst.notes
  end

  def test_notes_span
    assert_raise(RuntimeError) { @inst.notes = 9 }
  end

  def test_set_lower_key
    @dump[0x03] = 126
    assert_equal "F#8", @inst.lower_key_limit_name
  end

  def test_set_lower_key_name
    @inst.lower_key_limit_name = "D#-2"
    assert_equal 3, @inst.lower_key_limit, "index of D#-2"
  end

  def test_set_upper_key
    @dump[0x02] = 125
    assert_equal "F8", @inst.upper_key_limit_name
  end

  def test_set_upper_key_name
    @inst.upper_key_limit_name = "E-2"
    assert_equal 4, @inst.upper_key_limit, "index of E-2"
  end
end
