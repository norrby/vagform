# -*- coding: undecided -*-
require 'memory'

require 'instrument'

class Configuration
  include Memory
  attr_reader :instruments

  @@LfoWaveforms = ["Sawtooth", "Square", "Triangle", "Sample and Hold"]
  @@MemoryLayout = {
    :voice_function_combine => Memory.define(0, 1, 0x08, 0x01),
    :lfo_speed => Memory.define(1, 127, 0x09, 0x7F),
    :amd => Memory.define(1, 127, 0x0A, 0x7F),
    :pmd => Memory.define(1, 127, 0x0B, 0x7F),
    :lfo_waveform_internal => Memory.define(0, 3, 0x0C, 0x03),
    :kc_reception_mode => Memory.define(0, 2, 0x0D, 0x03),
  }

  Memory.accessors(@@MemoryLayout)

  def initialize(midi, backing_store = Array.new(0xA0, 0))
    @comm = midi
    @parameters = @@MemoryLayout
    @data = backing_store
    @instruments = (1..8).to_a.collect {|n| Instrument.new(midi, backing_store[0x10 + n * 0x10, 0x10])}
    @instruments.each_with_index {|inst, id| inst.instrument_no = id + 1}
  end

  def name
    @data[0..6].inject("") { |result, char| result << char }
  end

  def bulk_fetch(&block)
    dump = []
    @comm.sysex([0x43, 0x75, @comm.system_channel - 1, 0x20, 0x01, 0x00])
    catch :done do
      @comm.capture(:format => :Raw) do |data|
        dump.concat(data)
        next if dump.length < 9
        stated_packet_size = ((dump[0x07] & 0x01) << 7) + dump[0x08]
        block.call(stated_packet_size, 7, dump.length) if block
        throw :done if dump.length >= (stated_packet_size + 11)
      end
    end
    @data = dump[0x09..-3]
    @instruments.each_with_index {|inst, n| inst.replace_memory(@data[0x20 + n * 0x10, 0x10])}
  end

  def name=(name)
    (0..6).to_a.each {|idx| set(idx, 0x7F, (name[idx] || " ").ord)}
  end

  def send_to_fb01(pos, data)
    @comm.sysex([0x43, 0x75, @comm.system_channel - 1, 0x10, pos, data])
  end

  def lfo_waveforms
    return @@LfoWaveforms
  end

  def lfo_waveform=(waveform)
    index_of_provided_wf = @@LfoWaveforms.index(waveform)
    raise ArgumentError, "unknown LFO waveform " + waveform if not index_of_provided_wf
    self.lfo_waveform_internal = index_of_provided_wf
  end

  def lfo_waveform
    @@LfoWaveforms[lfo_waveform_internal]
  end

end
