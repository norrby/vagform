require 'model_bindings'

class FB01Instrument < NSViewController
  include ModelBindings
  attr_writer :configuration, :view_parent
  attr_writer :notes_selector, :channel_selector, :output_level_indicator
  attr_writer :instrument_pointer, :title
  attr_reader :chosen

  def instrument
    @configuration.instrument(self)
  end

  def model
    instrument
  end

  def instrument_no
    instrument.no
  end

  def select_instrument(sender)
    if sender.state == 1
      sender.setState(0)
      return
    end
    select_me
  end

  def select_me
    @instrument_pointer.setState(0)
    @chosen = true
    @configuration.selected_instrument_is(self)
    invalidate
  end

  def deselect_me
    @instrument_pointer.setState(1)
    @chosen = false
    invalidate
  end

  def invalidate
    @notes_selector.setFloatValue(instrument.notes)
    @output_level_indicator.setFloatValue(instrument.output_level)
    @channel_selector.setSelected(true, forSegment:(instrument.midi_channel - 1))
  end

  def midi_channel_selected(sender)
    instrument.midi_channel = sender.indexOfSelectedItem.to_i + 1
    invalidate
  end

  def notes_checked(sender)
    total = @configuration.total_notes
    puts "total notes are: #{total}"
    notes = sender.intValue
    if total - model.notes + notes > model.max_notes
      puts "setting notes to"
      model.notes = model.max_notes - total + model.notes
    else
      model.notes = notes
    end
    invalidate
  end

  def awakeFromNib
    return if @view_parent.subviews.include? view
    @view_parent.addSubview(view)
    no_channels = instrument.max_midi_channel - instrument.min_midi_channel + 1
    @channel_selector.setSegmentCount(no_channels)
    (instrument.min_midi_channel..instrument.max_midi_channel).to_a.each_with_index do |ch, idx|
      @channel_selector.setLabel(ch.to_s, forSegment:idx)
      @channel_selector.setWidth(ch.to_s.length == 2 ? 22 : 13, forSegment:idx)
    end
    @title.setTitle("Instrument #{instrument_no}")
  rescue => e
    puts "Errors " + e.message
  end

end
