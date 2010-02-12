require 'memory'

class Voice
  include Memory
  attr_writer :comm

  @@MemoryLayout = {
    :lfo_speed => Memory.define(0, 255, 0x07, 0xFF),
    :users_code => Memory.define(0, 255, 0x08, 0xFF),
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
    :lfo_waveform => Memory.define(0, 3, 0x0E, 0x60),
    :transpose_internal => Memory.define(0, 255, 0x0F, 0xFF),
    :mono => Memory.define(0, 1, 0x3A, 0x80),
    :portamento_time => Memory.define(0, 127, 0x3A, 0x7F),
    :pmd_controller_no => Memory.define(0, 4, 0x3B, 0x70),
    :pitchbender_range => Memory.define(0, 12, 0x3B, 0x07)
  }

  @@PmdControllers = ["Not assigned", "After touch", "Modulation
  wheel", "Breath controller", "Foot controller"]

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

  def transpose
    puts transpose_internal
    self.transpose_internal - 128
  end

  def transpose=(transpose)
    self.transpose_internal = transpose + 128
  end

  def max_transpose
    max_transpose_internal - 128
  end

  def min_transpose
    min_transpose_internal - 128
  end
end
