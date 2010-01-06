# -*- coding: iso-8859-1 -*-
require 'test/unit'
require 'voice'

class VoiceTest < Test::Unit::TestCase
  def setup
    @dump = Array.new(0x40, 0)
    @voice = Voice.new(@dump)
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
    assert_equal name, stored_name
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

  def test_amd=
    amd = 111
    @voice.amd = 111
    assert_equal amd | 0x80, @dump[0x09], "should set load lfo data"
    amd2 = 74
    @voice.amd = amd2
    assert_equal amd2 | 0x80, @dump[0x09], "should set load lfo data"
    assert_raise(RuntimeError) { @voice.amd = -1 }
    assert_raise(RuntimeError) { @voice.amd = 128 }
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

  def test_sync_lfo_at_note_on?
    @dump[0x0A] = 0x80
    assert @voice.sync_lfo_at_note_on?
  end

  def test_sync_lfo_at_note_on=
    @voice.sync_lfo_at_note_on = true
    assert @voice.sync_lfo_at_note_on?
    @voice.sync_lfo_at_note_on = false
    assert (not @voice.sync_lfo_at_note_on?)
  end

  def test_operator_enabled?
    @dump[0x0B] = 0x58
    assert @voice.operator_enabled?(3, 1, 0)
    assert (not @voice.operator_enabled?(2))
  end

  def test_enable_operator
    @voice.enable_operator(1, 2, 3)
    assert @voice.operator_enabled?(3, 2, 1)
    assert (not @voice.operator_enabled?(4))
    @voice.enable_operator(1, 3)
    assert @voice.operator_enabled?(1, 3)
    assert_raise(RuntimeError) { @voice.enable_operator(-1) }
    assert_raise(RuntimeError) { @voice.enable_operator(4) }
    assert_raise(RuntimeError) { @voice.enable_operator(2.9) }
    assert_raise(RuntimeError) { @voice.enable_operator("1") }
  end

  def test_disable_operator
    @voice.enable_operator(1, 2, 3, 4)
    @voice.disable_operator(1, 4)
    assert (not @voice.operator_enabled?(1, 4))
  end

  def test_feedback_level
    @dump[0x0C] = 0x28
    assert_equal 5, @voice.feedback_level
  end

  def test_feedback_level=
    expected_feedback = 7
    @voice.feedback_level = expected_feedback
    assert_equal expected_feedback, @voice.feedback_level
    assert_raise(RuntimeError) { @voice.feedback_level = -1 }
    assert_raise(RuntimeError) { @voice.feedback_level = 8 }
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
    feedback = 7
    @voice.algorithm = algorithm
    @voice.feedback_level = feedback
    assert_equal algorithm, @voice.algorithm
    assert_equal feedback, @voice.feedback_level
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
    assert_equal "Noise", @voice.lfo_waveform
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
    assert_raise(RuntimeError) { @voice.lfo_waveform = 1 }
    assert_raise(RuntimeError) { @voice.lfo_waveform = "Basuntuta" }
  end

  def test_transpose
    transpose = 242
    @dump[0x0F] = transpose
    assert_equal transpose, @voice.transpose
  end

  def test_transpose=
    transpose = 243
    @voice.transpose = transpose
    assert_equal transpose, @voice.transpose
    assert_raise(RuntimeError) { @voice.transpose = -1 }
    assert_raise(RuntimeError) { @voice.transpose = 256 }
  end

  def test_poly
    @dump[0x3A] = 0x80
    assert @voice.poly?
    assert (not @voice.mono?)
  end

  def test_mono
    @dump[0x3A] = 0x00
    assert @voice.mono?
    assert (not @voice.poly?)
  end

  def test_poly=
    @voice.poly = true
    assert @voice.poly?
    assert (not @voice.mono?)
  end

  def test_mono=
    @voice.mono = true
    assert @voice.mono?
    assert (not @voice.poly?)
  end

  def test_portamento
    portamento = 126
    @dump[0x3A] = portamento
    assert_equal portamento, @voice.portamento
  end

  def test_portamento=
    portamento = 113
    @voice.portamento = portamento
    assert_equal portamento, @voice.portamento
    portamento2 = 1
    @voice.portamento = portamento2
    assert_equal portamento2, @voice.portamento
    assert_raise(RuntimeError) { @voice.portamento = -1 }
    assert_raise(RuntimeError) { @voice.portamento = 128 }
  end

  def test_poly_and_portamento_dont_destroy_each_other
    portamento = 113
    @voice.poly = true
    @voice.portamento = portamento
    assert_equal portamento, @voice.portamento
    assert @voice.poly?
  end

  def test_pmd_input_controller
    @dump[0x3B] = 0x10
    assert_equal "Modulation wheel", @voice.pmd_controller
    @dump[0x3B] = 0x20
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

  def test_pitchbend_range
    range = 0x0F
    @dump[0x3B] = range
    assert_equal range, @voice.pitchbend_range 
  end

  def test_pitchbend_range=
    range = 0x07
    @voice.pitchbend_range = range
    assert_equal range, @voice.pitchbend_range
    range2 = 0x05
    @voice.pitchbend_range = range2
    assert_equal range2, @voice.pitchbend_range
    assert_raise(RuntimeError) { @voice.pitchbend_range = -1 }
    assert_raise(RuntimeError) { @voice.pitchbend_range = 16 }
  end

  def test_pmd_controller_and_pitchbend_dont_destroy_each_other
    controller = "Foot controller"
    range = 11
    @voice.pmd_controller = controller
    @voice.pitchbend_range = range
    assert_equal controller, @voice.pmd_controller
    assert_equal range, @voice.pitchbend_range
  end
end
