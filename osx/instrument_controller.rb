# -*- coding: iso-8859-1 -*-
require 'instrument'

class InstrumentController < NSViewController
  attr_accessor :where

  def initWithCoder(args)
    @model = Instrument.new
    super(args)
  end

  def min_output_level
    @model.min_output_level.to_i
  end

  def max_output_level
    @model.max_output_level.to_i
  end

  def output_level
    return @model.output_level.to_i
  end

  def setValue(val, forKey:key)
    send "set_#{key}", val 
  end

  def set_output_level(sender)
    @model.output_level = sender.intValue
  end

  #def method_missing(sym, *args, &block)
  #  puts "Called: #{sym}"
  #  @model.send sym, *args, &block
  #end

end
