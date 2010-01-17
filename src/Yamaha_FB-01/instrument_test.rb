# -*- coding: iso-8859-1 -*-
require 'test/unit'
require 'instrument'

class InstrumentTest < Test::Unit::TestCase
  def setup
    @dump = Array.new(0x10, 0)
    @inst = Instrument.new(@dump)
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
end
