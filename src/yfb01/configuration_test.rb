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
# -*- coding: undecided -*-
require 'test/unit'
require 'configuration'

class ConfigurationTest < Test::Unit::TestCase
  def setup
    @dump = Array.new(0xA0, 0)
    @conf = Configuration.new(nil, @dump)
    @observed_subject = nil
  end

  def action_method(subject)
    @observed_subject = subject
  end

  def test_observer
    @conf.pmd = 2
    assert_nil @observed_subject, "no callback before registration"
    @conf.subscribe(self, :action_method)
    pmd = 3
    @conf.pmd = pmd
    assert_equal pmd, @observed_subject.pmd
  end

  def test_observer_unsubscribe
    orig = 4
    @conf.pmd = orig
    assert_nil @observed_subject, "no callback before registration"
    @conf.subscribe(self, :action_method)
    @conf.unsubscribe(self)
    @conf.pmd = 7
    assert_nil @observed_subject
  end

  def test_lfo_speed
    lfo_speed = 125
    @dump[0x09] = lfo_speed
    assert_equal lfo_speed, @conf.lfo_speed
  end

  def test_name
    name = "Marimba"
    @conf.name = name
    assert_equal name, @conf.name
  end

  def test_amd
    amd = 127
    @conf.amd = amd
    assert_equal amd, @conf.amd
  end

  def test_lfo_waveform
    wf = "Triangle"
    @conf.lfo_waveform = wf
    assert_equal wf, @conf.lfo_waveform
  end

  def test_kc_reception_mode
    @conf.kc_reception_mode = 0x00
    assert_equal true, @conf.kc_reception_odd 
    assert_equal true, @conf.kc_reception_even
  end

  def test_kc_reception_odd
    @conf.kc_reception_mode = 0x02
    assert_equal true, @conf.kc_reception_odd 
    assert_equal false, @conf.kc_reception_even
  end

  def test_kc_reception_even
    @conf.kc_reception_mode = 0x01
    assert_equal true, @conf.kc_reception_even
    assert_equal false, @conf.kc_reception_odd 
  end

  def test_set_kc_reception_odd
    @conf.kc_reception_odd = true
    @conf.kc_reception_even = false
    assert_equal true, @conf.kc_reception_odd 
    assert_equal false, @conf.kc_reception_even
  end

  def test_set_kc_reception_even
    @conf.kc_reception_odd = false
    @conf.kc_reception_even = true
    assert_equal false, @conf.kc_reception_odd 
    assert_equal true, @conf.kc_reception_even
  end
end
