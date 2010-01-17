# -*- coding: iso-8859-1 -*-
require 'instrument'

class InstrumentController < NSViewController
  attr_accessor :where

  def initWithCoder(args)
    @model = Instrument.new
    super(args)
  end

  def midi_channels
    (@model.min_midi_channel .. @model.max_midi_channel).to_a
  end

  def lower_key_limits
    (@model.min_lower_key_limit .. @model.max_lower_key_limit).to_a
  end

  def lower_key_limits
    (@model.min_upper_key_limit .. @model.max_upper_key_limit).to_a
  end

  def min_output_level
    @model.min_output_level
  end

  def max_output_level
    @model.max_output_level
  end

  def output_level
    return @model.output_level
  end

  def setValue(val, forKey:key)
    puts "trying #{key}="
    @model.send "#{key}=".to_sym, val.to_i
    2
  end

  def detune
    @model.detune
  end

  def set_output_level(sender)
    @model.output_level = sender.intValue
  end

end
