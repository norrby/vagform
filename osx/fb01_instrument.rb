# fb01_instrument.rb
# FB-01_Editor
#
# Created by M Norrby on 2/2/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

class FB01Instrument < NSViewController
  attr_writer :configuration, :view_parent
  attr_writer :notes_selector, :channel_selector, :output_level_indicator
  attr_writer :instrument_pointer, :title

  def instrument
    @configuration.instrument(self)
  end

  def instrument_no
    instrument.no
  end

  def valueForKey(key)
    instrument.send key
  end

  def select_instrument(sender)
    if sender.state == 1
       sender.setState(0)
      return
    end
    @configuration.chose_instrument(self)
  end

  def deselect_instrument
    @instrument_pointer.setState(1)
  end

  def invalidate
    @notes_selector.setFloatValue(instrument.notes)
    @output_level_indicator.setFloatValue(instrument.output_level)
    @channel_selector.setSelected(true, forSegment:(instrument.midi_channel - 1))
  end

  def setValue(value, forKey:key)
    value = value.to_i if value.class == Float
    value = 1 if value.class == TrueClass
    value = 0 if value.class == FalseClass
    instrument.send key + "=", value
    invalidate
  end

  def midi_channel_selected(sender)
    instrument.midi_channel = sender.indexOfSelectedItem.to_i + 1
    invalidate
  end

  def awakeFromNib
    @view_parent.addSubview(view)
    no_channels = instrument.max_midi_channel - instrument.min_midi_channel + 1
    @channel_selector.setSegmentCount(no_channels)
    (instrument.min_midi_channel..instrument.max_midi_channel).to_a.each_with_index do |ch, idx|
      @channel_selector.setLabel(ch.to_s, forSegment:idx)
      @channel_selector.setWidth(ch.to_s.length == 2 ? 22 : 13, forSegment:idx)
    end
    @title.setTitle("Instrument #{instrument_no}")
  rescue => e
    puts "Error " + e.message
  end

end
