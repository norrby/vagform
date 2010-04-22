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
require 'voice'

class VoiceTest < Test::Unit::TestCase
  def setup
    @dump = Array.new(0x40, 0)
    @voice = Voice.new(nil, 0, @dump)
  end

  def test_name
    name = "NameGet"
    name.unpack("C"*7).each_with_index { |ch, idx| @dump[idx] = ch }
    assert_equal name, @voice.name
  end

  def test_name=
    name = "NamSet"
    @voice.name = name
    stored_name = @dump[0..6].inject("") { |result, ch| result << (ch != 0 ? ch.chr : "") }
    assert_equal name, stored_name[0..name.length-1]
  end

  def test_lfo_speed
    lfo_speed = 117
    @dump[0x08] = lfo_speed
    assert_equal lfo_speed, @voice.lfo_speed
  end

  def test_lfo_speed=
    lfo_speed = 211
    @voice.lfo_speed = lfo_speed
    assert_equal lfo_speed, @voice.lfo_speed
    assert_raise(RuntimeError) { @voice.lfo_speed = -1 }
    assert_raise(RuntimeError) { @voice.lfo_speed = 256 }
  end

  def test_amd
    amd = 127
    @dump[0x09] = amd
    assert_equal amd, @voice.amd
  end

  def test_pmd
    pmd = 126
    @dump[0x0A] = pmd
    assert_equal pmd, @voice.pmd
  end

  def test_pmd=
    pmd = 111
    @dump[0x0A] = 0x80
    @voice.pmd = 111
    assert_equal pmd + 0x80, @dump[0x0A], "must preserve high bit"
    assert_raise(RuntimeError) { @voice.pmd = -1 }
    assert_raise(RuntimeError) { @voice.pmd = 128 }
  end

  def test_sync_lfo
    @dump[0x0A] = 0x80
    assert @voice.sync_lfo
  end

  def test_sync_lfo=
    @voice.sync_lfo = 1
    assert_equal 1, @voice.sync_lfo
  end

  def test_feedback_level
    @dump[0x0C] = 0x28
    assert_equal 5, @voice.feedback
  end

  def test_feedback=
    expected_feedback = 6
    @voice.feedback = expected_feedback
    assert_equal expected_feedback, @voice.feedback
    assert_raise(RuntimeError) { @voice.feedback = -1 }
    assert_raise(RuntimeError) { @voice.feedback = 8 }
  end

  def test_algorithm
    expected_algorithm = 7
    @dump[0x0C] = expected_algorithm
    assert_equal expected_algorithm, @voice.algorithm
  end

  def test_algorithm=
    expected_algorithm = 7
    @voice.algorithm = expected_algorithm
    assert_equal expected_algorithm, @voice.algorithm
    second_expected_algorithm = 5
    @voice.algorithm = second_expected_algorithm
    assert_equal second_expected_algorithm, @voice.algorithm
    assert_raise(RuntimeError) { @voice.algorithm = -1 }
    assert_raise(RuntimeError) { @voice.algorithm = 8 }
  end

  def test_feedback_and_algorithm_does_not_destroy_each_other
    algorithm = 5
    feedback = 6
    @voice.algorithm = algorithm
    @voice.feedback = feedback
    assert_equal algorithm, @voice.algorithm
    assert_equal feedback, @voice.feedback
  end

  def test_pms
    @dump[0x0D] = 0x50
    assert_equal 5, @voice.pms
  end

  def test_pms=
    expected_pms = 7
    @voice.pms = expected_pms
    assert_equal expected_pms, @voice.pms
    second_expected_pms = 5
    @voice.pms = second_expected_pms
    assert_equal second_expected_pms, @voice.pms
    assert_raise(RuntimeError) { @voice.pms = -1 }
    assert_raise(RuntimeError) { @voice.pms = 8 }
  end

  def test_ams
    expected_ams = 3
    @dump[0x0D] = expected_ams
    assert_equal expected_ams, @voice.ams
  end

  def test_ams=
    expected_ams = 3
    @voice.ams = expected_ams
    assert_equal expected_ams, @voice.ams
    second_expected_ams = 2
    @voice.ams = second_expected_ams
    assert_equal second_expected_ams, @voice.ams
    assert_raise(RuntimeError) { @voice.ams = -1 }
    assert_raise(RuntimeError) { @voice.ams = 4 }
  end

  def test_pms_and_ams_does_not_destroy_each_other
    ams = 2
    pms = 7
    @voice.ams = ams
    @voice.pms = pms
    assert_equal ams, @voice.ams
    assert_equal pms, @voice.pms
  end

  def test_lfo_waveform
    @dump[0x0E] = 0x60
    assert_equal "Sample and Hold", @voice.lfo_waveform
    @dump[0x0E] = 0x00
    assert_equal "Sawtooth", @voice.lfo_waveform
    @dump[0x0E] = 0x20
    assert_equal "Square", @voice.lfo_waveform
    @dump[0x0E] = 0x40
    assert_equal "Triangle", @voice.lfo_waveform
  end

  def test_lfo_waveform=
    waveform = "Triangle"
    @voice.lfo_waveform=(waveform)
    assert_equal waveform, @voice.lfo_waveform
    sawtooth = "Sawtooth"
    @voice.lfo_waveform=(sawtooth)
    assert_equal sawtooth, @voice.lfo_waveform
    assert_raise(TypeError) { @voice.lfo_waveform = 1 }
    assert_raise(ArgumentError) { @voice.lfo_waveform = "Basuntuta" }
  end

  def test_transpose_positive
    transpose = 114
    @dump[0x0F] = transpose
    assert_equal transpose, @voice.transpose
  end

  def test_transpose_negative
    transpose = 255
    @dump[0x0F] = transpose
    assert_equal -1, @voice.transpose
  end

  def test_enable_operators
    @voice.op4_enable = 1
    assert_equal 1, @voice.op4_enable
    assert_equal 0, @voice.op3_enable
    assert_equal 0, @voice.op2_enable
    assert_equal 0, @voice.op1_enable
    @voice.op3_enable = 1
    assert_equal 1, @voice.op4_enable
    assert_equal 1, @voice.op3_enable
    assert_equal 0, @voice.op2_enable
    assert_equal 0, @voice.op1_enable
    @voice.op4_enable = 0
    @voice.op1_enable = 1
    assert_equal 0, @voice.op4_enable
    assert_equal 1, @voice.op3_enable
    assert_equal 0, @voice.op2_enable
    assert_equal 1, @voice.op1_enable
    @voice.op3_enable = 1
    @voice.op2_enable = 1
    @voice.op1_enable = 0
    assert_equal 0, @voice.op4_enable
    assert_equal 1, @voice.op3_enable
    assert_equal 1, @voice.op2_enable
    assert_equal 0, @voice.op1_enable
  end

  def test_mono
    @dump[0x3A] = 0x00
    assert @voice.mono
  end

  def test_mono=
    @voice.mono = 1
    assert @voice.mono
  end

  def test_portamento
    portamento = 126
    @dump[0x3A] = portamento
    assert_equal portamento, @voice.portamento_time
  end

  def test_portamento=
    portamento = 113
    @voice.portamento_time = portamento
    assert_equal portamento, @voice.portamento_time
    portamento2 = 1
    @voice.portamento_time = portamento2
    assert_equal portamento2, @voice.portamento_time
    assert_raise(RuntimeError) { @voice.portamento_time = -1 }
    assert_raise(RuntimeError) { @voice.portamento_time = 128 }
  end

  def test_mono_and_portamento_dont_destroy_each_other
    portamento = 113
    @voice.mono = 1
    @voice.portamento_time = portamento
    assert_equal portamento, @voice.portamento_time
    assert_equal 1, @voice.mono
  end

  def test_pmd_input_controller
    @dump[0x3B] = 0x20
    assert_equal "Modulation wheel", @voice.pmd_controller
    @dump[0x3B] = 0x30
    assert_equal "Breath controller", @voice.pmd_controller
    @dump[0x3B] = 0x40
    assert_equal "Foot controller", @voice.pmd_controller
  end

  def test_pmd_controller=
    controller = "Breath controller"
    @voice.pmd_controller=(controller)
    assert_equal controller, @voice.pmd_controller
    foot = "Foot controller"
    @voice.pmd_controller=(foot)
    assert_equal foot, @voice.pmd_controller
    assert_raise(RuntimeError) { @voice.pmd_controller = 3 }
    assert_raise(RuntimeError) { @voice.pmd_controller = "Limknekt" }
  end

  def test_pitchbender_range
    range = 0x07
    @dump[0x3B] = range
    assert_equal range, @voice.pitchbender_range 
  end

  def test_pitchbender_range=
    range = 0x07
    @voice.pitchbender_range = range
    assert_equal range, @voice.pitchbender_range
    range2 = 0x05
    @voice.pitchbender_range = range2
    assert_equal range2, @voice.pitchbender_range
    assert_raise(RuntimeError) { @voice.pitchbender_range = -1 }
    assert_raise(RuntimeError) { @voice.pitchbender_range = 13 }
  end

  def test_pmd_controller_and_pitchbend_dont_destroy_each_other
    controller = "Foot controller"
    range = 11
    @voice.pmd_controller = controller
    @voice.pitchbender_range = range
    assert_equal controller, @voice.pmd_controller
    assert_equal range, @voice.pitchbender_range
  end
end
