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
end
