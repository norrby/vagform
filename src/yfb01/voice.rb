require 'memory'
require 'operator'
require 'named'
require 'array_part'
require 'observable'
require 'pmd_controllers'
require 'lfo_waveform'

class Voice
  include Memory
  include Observable
  include Named
  include PmdControllers
  include LfoWaveform

  attr_writer :comm
  attr_reader :operators

  @@MemoryLayout = {
    :users_code => Memory.define(0, 255, 0x07, 0xFF),
    :lfo_speed => Memory.define(0, 255, 0x08, 0xFF),
    :load_lfo => Memory.define(0, 1, 0x09, 0x80),
    :amd => Memory.define(0, 127, 0x09, 0x7F),
    :sync_lfo => Memory.define(0, 1, 0x0A, 0x80),
    :pmd => Memory.define(0, 127, 0x0A, 0x7F),
    :op3_enable => Memory.define(0, 1, 0x0B, 0x40),
    :op2_enable => Memory.define(0, 1, 0x0B, 0x20),
    :op1_enable => Memory.define(0, 1, 0x0B, 0x10),
    :op0_enable => Memory.define(0, 1, 0x0B, 0x08),
    :feedback => Memory.define(0, 6, 0x0C, 0x38),
    :algorithm => Memory.define(0, 7, 0x0C, 0x07),
    :pms => Memory.define(0, 7, 0x0D, 0x70),
    :ams => Memory.define(0, 3, 0x0D, 0x03),
    :lfo_waveform_no => Memory.define(0, 3, 0x0E, 0x60),
    :transpose_internal => Memory.define(0, 255, 0x0F, 0xFF),
    :mono => Memory.define(0, 1, 0x3A, 0x80),
    :portamento_time => Memory.define(0, 127, 0x3A, 0x7F),
    :pmd_controller_no => Memory.define(0, 4, 0x3B, 0x70),
    :pitchbender_range => Memory.define(0, 12, 0x3B, 0x0F)
  }

  Memory.accessors(@@MemoryLayout)

  def self.null
    return @null if @null
    @null = Voice.new(nil, Instrument.null)
  end

  def initialize(midi, instrument, backing_store = Array.new(0x80, 0))
    @parameters = @@MemoryLayout
    @comm = midi
    @instrument = instrument
    @data = backing_store
    @operators = [Operator.new(midi, ArrayPart.new(backing_store, 0x10, 0x17), 0x00, instrument),
                  Operator.new(midi, ArrayPart.new(backing_store, 0x18, 0x1F), 0x08, instrument),
                  Operator.new(midi, ArrayPart.new(backing_store, 0x20, 0x27), 0x10, instrument),
                  Operator.new(midi, ArrayPart.new(backing_store, 0x28, 0x2F), 0x18, instrument)]
  end

  def replace_memory(new_bulk)
    new_bulk.each_with_index {|value, idx| @data[idx] = value}
    notify_observers
    @operators.each {|operator| operator.notify_observers}
  end
    
  def send_to_fb01(pos, data)
    channel_index = @comm.system_channel - 1
    instrument_index = @instrument.no - 1
    @comm.sysex([0x43, 0x75, channel_index, 0x18 + instrument_index, pos + 0x40,
                 data & 0x0F, (data & 0xF0) >> 4])
  end

  def transpose
    internal = self.transpose_internal
    return internal if internal < 128
    -256 + internal
  end

  def transpose=(transpose)
    self.transpose_internal = transpose if transpose < 128
    self.transpose_internal = 0xFF & transpose
  end

  def max_transpose
    max_transpose_internal - 128
  end

  def min_transpose
    min_transpose_internal - 128
  end
end
