require 'memory'
require 'timeout'
require 'voice'

class Instrument
  include Memory
  include Timeout
  attr_writer :instrument_no
  attr_reader :comm, :voice

  @@Tones = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "H"]
  @@Keys = (-2..8).to_a.collect do |num| @@Tones.collect {|tone| "#{tone}#{num}" } end.flatten[0..127]

  @@MemoryLayout = {
    :notes => Memory.define(0, 8, 0x00, 0x0F),
    :midi_channel_internal => Memory.define(0, 15, 0x01, 0x0F),
    :upper_key_limit => Memory.define(0, @@Keys.length - 1, 0x02, 0x7F),
    :lower_key_limit => Memory.define(0, @@Keys.length - 1, 0x03, 0x7F),
    :voice_bank_no => Memory.define(0, 6, 0x04, 0x07),
    :voice_no => Memory.define(0, 47, 0x05, 0x7F),
    :detune => Memory.define(0, 127, 0x06, 0x7F),
    :octave_transpose_internal => Memory.define(0, 4, 0x07, 0x07),
    :output_level => Memory.define(0, 127, 0x08, 0x7F),
    :pan_internal => Memory.define(0, 127, 0x09, 0x7F),
    :lfo_enable => Memory.define(0, 1, 0x0A, 0x01),
    :portamento_time => Memory.define(0, 127, 0x0B, 0x7F),
    :pitchbender_range => Memory.define(0, 12, 0x0C, 0x0F),
    :mono => Memory.define(0, 1, 0x0D, 0x01),
    :pmd_controller_no => Memory.define(0, 4, 0x0E, 0x07)
  }

  @@PmdControllers = ["Not assigned", "After touch", "Modulation
  wheel", "Breath controller", "Foot controller"]

  Memory.accessors(@@MemoryLayout)

  def initialize(midi, backing_store = Array.new(0x10, 0))
    @parameters = @@MemoryLayout
    @comm = midi
    @data = backing_store
    @voice = Voice.new(midi, self)
  end

  def replace_memory(new_bulk)
    @data = new_bulk
  end

  def read_voice_data_from_fb01(&block)
    request = [0x43, 0x75, 0x00 + @comm.system_channel - 1, 0x28 + no - 1, 0x00, 0x00]
    raw_response = [0xF0, 0x43, 0x75, 0x00 + @comm.system_channel - 1, 0x08 + no - 1, 0x00, 0x00]
    data = @comm.receive_interleaved_dump(request, raw_response)
    @voice.replace_memory(data) if data
  rescue =>e
    puts "timeout? #{e}"
  end

  def no
    @instrument_no
  end

  def send_to_fb01(pos, data)
    channel_index = @comm.system_channel - 1
    instrument_index = no - 1
    @comm.sysex([0x43, 0x75, channel_index, 0x18 + instrument_index, pos, data])
  end

  def midi_channel
    self.midi_channel_internal + 1
  end

  def midi_channel=(ch)
    self.midi_channel_internal = ch - 1
  end

  def min_midi_channel
    self.min_midi_channel_internal + 1
  end

  def max_midi_channel
    self.max_midi_channel_internal + 1
  end

  def pan
    self.pan_internal - 64
  end

  def pan=(pan)
    self.pan_internal = pan + 64
  end

  def min_pan
    self.min_pan_internal - 64
  end

  def max_pan
    self.max_pan_internal - 64
  end

  def octave_transpose
    self.octave_transpose_internal - 2
  end

  def octave_transpose=(transpose)
    self.octave_transpose_internal = transpose + 2
  end

  def min_octave_transpose
    self.min_octave_transpose_internal - 2
  end

  def max_octave_transpose
    self.max_octave_transpose_internal - 2
  end

  def pmd_controller
    @@PmdControllers[pmd_controller_no]
  end

  def pmd_controller=(controller_name)
    if not @@PmdControllers.index(controller_name)
      raise "There is no \"#{controller_name}\" controller." +
        "Only #{@@PmdControllers.values}"
    end
    controller_num = @@PmdControllers.key(controller_name)
  end

  def pmd_controllers
    @@PmdControllers
  end

  def lower_key_limit_name
    @@Keys[lower_key_limit]
  end

  def lower_key_limit_name=(name)
    index = @@Keys.index(name)
    raise "There is no \"#{name}\" key. Only #{@@Keys.values}" if not index
    self.lower_key_limit = index
  end

  def key_to_number(key)
    @@Keys.index(key)
  end

  def upper_key_limit_checked
    self.upper_key_limit
  end

  def upper_key_limit_checked=(upper_limit)
    self.upper_key_limit = upper_limit
    self.lower_key_limit = upper_limit if self.lower_key_limit > upper_key_limit
  end

  def lower_key_limit_checked
    self.lower_key_limit
  end

  def lower_key_limit_checked=(lower_limit)
    self.lower_key_limit = lower_limit
    self.upper_key_limit = lower_limit if self.upper_key_limit < lower_key_limit
  end

  def upper_key_limit_name
    @@Keys[upper_key_limit]
  end

  def upper_key_limit_name=(name)
    index = @@Keys.index(name)
    raise "There is no \"#{name}\" key. Only #{@@Keys.values}" if not index
    self.upper_key_limit = index
  end

  def keys
    @@Keys
  end
end
