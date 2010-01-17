# -*- coding: iso-8859-1 -*-
require 'instrument'

class InstrumentController < NSViewController
  attr_writer :upper_key_limit_slider, :upper_key_limit_field
  attr_writer :lower_key_limit_slider, :lower_key_limit_field
  attr_writer :midi_channel_selector
  attr_accessor :where

  def initWithCoder(args)
    @model = Instrument.new
    super(args)
  end

  def midi_channel_changed(sender)
    @model.midi_channel = sender.selectedSegment + 1
    invalidate
  end

  def lowest_key_number
    @model.min_lower_key_limit
  end

  def highest_key_number
    @model.max_upper_key_limit
  end

  def min_output_level
    @model.min_output_level
  end

  def max_output_level
    @model.max_output_level
  end

  def upper_key_limit
    @model.upper_key_limit
  end

  def upper_key_limit=(limit)
    new_limit = limit.to_i
    @model.upper_key_limit = new_limit if new_limit >= lower_key_limit
  end

  def upper_key_limit_name=(name)
    begin
      @model.upper_key_limit_name = name if @model.key_to_number(name) >= lower_key_limit
    rescue
      # entered crap
    end
  end

  def upper_key_limit_name
    @model.upper_key_limit_name
  end

  def lower_key_limit
    @model.lower_key_limit
  end

  def lower_key_limit=(limit)
    new_limit = limit.to_i
    @model.lower_key_limit = new_limit if new_limit <= upper_key_limit
  end

  def lower_key_limit_name=(name)
    begin
      @model.lower_key_limit_name = name if @model.key_to_number(name) <= upper_key_limit
    rescue
      # entered crap
    end
  end

  def lower_key_limit_name
    @model.lower_key_limit_name
  end

  def output_level
    return @model.output_level
  end

  def setValue(val, forKey:key)
    puts "trying #{key}="
    send "#{key}=".to_sym, val
    invalidate
  end

  def invalidate
    @upper_key_limit_slider.setIntValue(@model.upper_key_limit)
    @upper_key_limit_field.setStringValue(@model.upper_key_limit_name)
    @lower_key_limit_slider.setIntValue(@model.lower_key_limit)
    @lower_key_limit_field.setStringValue(@model.lower_key_limit_name)
    @midi_channel_selector.setSelectedSegment(@model.midi_channel - 1)
  end

  def claviature
    @model.keys
  end

  def detune
    @model.detune
  end


end
