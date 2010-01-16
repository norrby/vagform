class Instrument

  attr_accessor :min_notes, :max_notes, :min_output_level, :max_output_level

  def initialize(dump = Array.new(0x10, 0))
    @data = dump
    @min_notes = 0
    @max_notes = 8
    @min_output_level = 0
    @max_output_level = 127
  end

  def notes
    @data[0x00] & 0x0F
  end

  def output_level
    @data[0x08] & 0x7F
  end

  def output_level=(level)
    @data[0x08] = (@data[0x08] & 0x80) & level
  end
end

