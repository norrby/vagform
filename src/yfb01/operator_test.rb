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
require 'operator'

class OperatorTest < Test::Unit::TestCase
  def setup
    @dump = Array.new(0x08, 0)
    @op = Operator.new(@dump)
  end

  def test_tl
    tl = 111
    @dump[0x00] = tl
    assert_equal tl, @op.tl
  end

  def test_velocity_sensitivity
    sensitivity = 5
    @dump[0x01] = 0xD0
    assert_equal sensitivity, @op.tl_velocity_sensitivity
  end

  def test_keyboard_level_scaling_type
    @op.scaling_internal_bit0 = 1
    @op.scaling_internal_bit1 = 1
    assert_equal 3, @op.level_scaling_type
  end

  def test_keyboard_level_scaling_type
    type = 3
    @op.level_scaling_type = type
    assert_equal type, @op.level_scaling_type
  end

  def test_keyboard_level_scaling_depth
    depth = 11
    @op.level_scaling_depth = depth
    assert_equal depth, @op.level_scaling_depth
  end

  def test_detune
    detune = 5
    @op.detune = detune
    assert_equal detune, @op.detune
  end

  def test_adjust_for_tl
    adjust = 15
    @op.adjust_for_tl = adjust
    assert_equal adjust, @op.adjust_for_tl
  end

  def test_detune_freq
    freq = 12
    @op.detune_frequency = freq
    assert_equal freq, @op.detune_frequency
  end

  def test_interference
    mul = 12
    dt1 = 6
    type = 3
    depth = 14
    adjust = 8
    @op.level_scaling_type = type
    @op.detune = dt1
    @op.detune_frequency = mul
    @op.level_scaling_depth = depth
    @op.adjust_for_tl = adjust
    assert_equal dt1, @op.detune, "detune"
    assert_equal mul, @op.detune_frequency, "detune freq"
    assert_equal depth, @op.level_scaling_depth, "scaling_depth"
    assert_equal adjust, @op.adjust_for_tl, "adjust for tl"
    assert_equal type, @op.level_scaling_type, "scaling type"
  end

  def test_carrier
    carrier = 1
    @op.carrier = carrier
    assert_equal carrier, @op.carrier
  end

  def test_ar_velocity_sensitivity
    sensitivity = 2
    @op.ar_velocity_sensitivity = sensitivity
    assert_equal sensitivity, @op.ar_velocity_sensitivity
  end

  def test_d1r
    d1r = 27
    @op.d1r = d1r
    assert_equal d1r, @op.d1r
  end

  def test_inharmonic_frequency
    f = 1
    @op.inharmonic_frequency = f
    assert_equal f, @op.inharmonic_frequency
  end

  def test_d2r
    d2r = 13
    @op.d2r = d2r
    assert_equal d2r, @op.d2r
  end

  def test_sl
    sl = 11
    @op.sl = sl
    assert_equal sl, @op.sl
  end

  def test_rr
    rr = 15
    @op.rr = rr
    assert_equal rr, @op.rr
  end

end
