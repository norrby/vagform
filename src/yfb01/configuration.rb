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

  def bulk_fetch(&block)
    request = [0x43, 0x75, @comm.system_channel - 1, 0x20, 0x01, 0x00]
    raw_response = [0xF0, 0x43, 0x75, @comm.system_channel - 1, 0x00, 0x01, 0x00]
    dump = @comm.receive_dump(request, raw_response) 
    return unless dump
    @data = dump
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
