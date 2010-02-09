require 'memory'

class Voice
  include Memory
  attr_writer :comm

  @@MemoryLayout = {
    :lfo_speed => Memory.define(0, 255, 0x08, 0xFF),
    :users_code => Memory.define(0, 255, 0x09, 0xFF),
  }

  Memory.accessors(@@MemoryLayout)

  def initialize(midi, instrument, backing_store = Array.new(0x80, 0))
    @parameters = @@MemoryLayout
    @comm = midi
    @instrument = instrument
    @data = backing_store
  end

  def replace_memory(new_bulk)
    @data = new_bulk
  end
    
  def send_to_fb01(pos, data)
    channel_index = @comm.system_channel - 1
    instrument_index = @instrument.no - 1
    @comm.sysex([0x43, 0x75, channel_index, 0x18 + instrument_index, pos + 0x40,
                 data & 0x0F, (data & 0xF0) >> 4])
  end

  def name
    @data[0..6].inject("") { |result, char| result << char }
  end

  def name=(name)
    (0..6).to_a.each {|idx| set(idx, 0x7F, (name[idx] || " ").ord)}
  end
end
