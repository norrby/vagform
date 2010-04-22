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
require 'observable'
require 'named'
require 'memory'
require 'lfo_waveform'
require 'instrument'

class Configuration
  include Memory
  include Named
  include Observable
  include LfoWaveform

  attr_reader :instruments

  @@MemoryLayout = {
    :voice_function_combine => Memory.define(0, 1, 0x08, 0x01),
    :lfo_speed => Memory.define(1, 127, 0x09, 0x7F),
    :amd => Memory.define(1, 127, 0x0A, 0x7F),
    :pmd => Memory.define(1, 127, 0x0B, 0x7F),
    :lfo_waveform_no => Memory.define(0, 3, 0x0C, 0x03),
    :kc_reception_mode => Memory.define(0, 2, 0x0D, 0x03),
  }

  Memory.accessors(@@MemoryLayout)

  def initialize(midi, backing_store = Array.new(0xA0, 0))
    @comm = midi
    @parameters = @@MemoryLayout
    @data = backing_store
    @instruments = (0..7).to_a.collect do |n|
      Instrument.new(midi, instrument_memory(backing_store, n))
    end
    @instruments.each_with_index {|inst, id| inst.instrument_no = id + 1}
  end

  def instrument_memory(backing_store, zero_based_number)
    n = zero_based_number
    base_addr = 0x20 + (n * 0x10)
    ArrayPart.new(backing_store, base_addr, base_addr + 0x0F)
  end

  def kc_reception_odd
    return 1 if kc_reception_mode == 0 or kc_reception_mode == 2
    0
  end

  def kc_reception_odd=(on)
    if on == 1
      self.kc_reception_mode = 0 if kc_reception_mode == 1
    else
      self.kc_reception_mode = 1 if kc_reception_mode == 0
    end
  end

  def kc_reception_even=(on)
    if on == 1
      self.kc_reception_mode = 0 if kc_reception_mode == 2
    else
      self.kc_reception_mode = 2 if kc_reception_mode == 0
    end
  end

  def kc_reception_even
    return 1 if kc_reception_mode == 0 or kc_reception_mode == 1
    0
  end

  def bulk_fetch(&block)
    request = [0x43, 0x75, @comm.system_channel - 1, 0x20, 0x01, 0x00]
    raw_response = [0xF0, 0x43, 0x75, @comm.system_channel - 1, 0x00, 0x01, 0x00]
    dump = @comm.receive_dump(request, raw_response) 
    return unless dump
    @data = dump
    notify_observers
    @instruments.each_with_index {|inst, n| inst.replace_memory(@data[0x20 + n * 0x10, 0x10])}
    @instruments.each_with_index do |inst, i|
      block.call(10, 1, 3 + i) if block
      inst.read_voice_data_from_fb01
    end
  ensure
    block.call(10, 1, 10) if block
  end

  def send_to_fb01(pos, data)
    @comm.sysex([0x43, 0x75, @comm.system_channel - 1, 0x10, pos, data])
  end

end
