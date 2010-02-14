require 'memory'

class Operator
  include Memory

  @@MemoryLayout = {
    :tl => Memory[0, 127, 0x00, 0x7F],
    :scaling_internal_bit0 => Memory[0, 1, 0x01, 0x80],
    :tl_velocity_sensitivity => Memory[0, 7, 0x01, 0x70],
    :level_scaling_depth => Memory[0, 15, 0x02, 0xF0],
    :adjust_for_tl => Memory[0, 15, 0x02, 0x0F],
    :scaling_internal_bit1 => Memory[0, 1, 0x03, 0x80],
    :dt1 => Memory[0, 7, 0x03, 0x70],
    :frequency_multiplier => Memory[0, 15, 0x03, 0x0F],
    :rate_scaling_depth => Memory[0, 3, 0x04, 0xC0],
    :ar => Memory[0, 31, 0x04, 0x1F],
    :carrier => Memory[0, 1, 0x05, 0x80],
    :ar_velocity_sensitivity => Memory[0, 3, 0x05, 0x60],
    :d1r => Memory[0, 31, 0x05, 0x1F],
    :dt2 => Memory[0, 3, 0x06, 0xC0],
    :d2r => Memory[0, 31, 0x06, 0x1F],
    :sl => Memory[0, 15, 0x07, 0xF0],
    :rr => Memory[0, 15, 0x07, 0x0F]
  }

  Memory.accessors(@@MemoryLayout)

  def initialize(backing_store = Array.new(0x08))
    @parameters = @@MemoryLayout
    @data = backing_store
  end

  def level_scaling_type
    self.scaling_internal_bit0 + (self.scaling_internal_bit1 << 1)
  end

  def detune_fine
    return 0 if dt1 == 0
    self.dt1 - 4
  end

  def detune_fine=(value)
    self.dt1 = value + 4
  end

  def min_detune_fine
    self.min_dt1 - 4
  end

  def max_detune_fine
    self.max_dt1 - 4
  end

  def total_level
    self.max_tl - self.tl
  end

  def total_level=(value)
    self.tl = self.max_tl - value
  end

  def max_total_level
    self.max_tl
  end

  def min_total_level
    self.min_tl
  end

  def level_scaling_type=(value)
    if value < 0 || value >3
      raise "keyboard level scaling type must be in the interval [1, 4]"
    end
    self.scaling_internal_bit0 = (value & 0x01)
    self.scaling_internal_bit1 = (value & 0x02) >> 1
  end
end
